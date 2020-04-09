import XCTest
@testable import StepForth

class ForthTests: XCTestCase {

    let forth = Forth()

    /* Should read and execute a line of FORTH */
    func testSimpleLineExecution() throws {
        ReadLine(forth, "10 20 30")
        StackShouldEqual(forth, "10 20 30 <- Top ")
    }

    /* Should handle weird spacing */
    func testWeirdSpacing() throws {
        ReadLine(forth, "100\t200     300 ")
        StackShouldEqual(forth, "100 200 300 <- Top ")
    }

    /* Should output stack underflow when there is an underflow */
    func testStackUnderflow() {
        ReadLine(forth, "10")
        XCTAssertEqual(forth.read(line: "+"), " Stack underflow")
    }

    /* Should handle missing words */
    func testMissingWords() {
        XCTAssertEqual(forth.read(line: "10 10 + foo"), " foo ? ")
    }

    // MARK: Defining Words

    /* Should define a new word */
    func testDefineWord() {
        ReadLine(forth, ": add-10  10 + ;")
        ReadLine(forth, "5 add-10")
        StackShouldEqual(forth, "15 <- Top ")
    }

    /* Should define a word with code before and after */
    func testDefineWordExtraCode() {
        ReadLine(forth, "100 : add-10  10 + ; 200")
        ReadLine(forth, "5 add-10")
        StackShouldEqual(forth, "100 200 15 <- Top ")
    }

    /* Should define a word over multiple lines */
    func testDefineWordMultipleLines() {
        // no output should be produced
        XCTAssertEqual(forth.read(line: ": add-20  10 + "), "")
        XCTAssertEqual(forth.read(line: " 5 + "), "")
        // final link has " ok" output
        ReadLine(forth, " 5 + ;")
        ReadLine(forth, "5 add-20")
        StackShouldEqual(forth, "25 <- Top ")
    }

    // MARK: Control Structures

    func testIfElseThen() {
        ReadLine(forth, ": foo  -1 if 1 else 2 then 3 ; ")
        ReadLine(forth, "foo")
        StackShouldEqual(forth, "1 3 <- Top ")
    }


    /*
     describe('defining words', function () {
       describe(': ;', function () {
         describe('with missing words in definition', function () {
           it('outputs error and stops definition', function (done) {
             executeInSequence([
               function () {
                 collectOutput(forth.readLine, ": add-20  10 + foo ", this);
               },
               function (output) {
                 expect(output).toBe(" foo ? "); // output error

                 collectOutput(forth.readLine, "5 5 + .", function (output) {
                   expect(output).toBe("10  ok"); // output because definition has finished
                   done();
                 });
               }
             ]);
           });
         });
       });
     });

     describe('input', function () {
       describe('key', function () {
         it('pauses execution of line until key is pressed', function (done) {
           forth.readLine("1 key 2", function () {
             expect(forth.getStack()).toBe("1 65 2 <- Top ");
             done();
           });

           // Call keydown in a setTimeout to simulate waiting for keyboard input
           setTimeout(function () {
             expect(forth.getStack()).toBe("1 <- Top ");
             forth.keydown(65);
           }, 5);
         });

         it('calls output callback appropriately before and after key press', function (done) {
           var output = [];

           forth.readLine("1 . key . 2 . key . 3 .", function (o) {
             output.push(o);
           }, function () {
             expect(output.join("")).toBe("1 65 2 66 3  ok");
             done();
           });

           // Call keydown in a setTimeout to simulate waiting for keyboard input
           setTimeout(function () {
             expect(output.join("")).toBe("1 ");
             forth.keydown(65);

             setTimeout(function () {
               expect(output.join("")).toBe("1 65 2 ");
               forth.keydown(66);
             }, 5);
           }, 5);
         });

         describe('in definition', function () {
           it('pauses execution of line until key is pressed', function (done) {
             executeInSequence([
               function () {
                 forth.readLine(": foo  1 key 2 ;", this);
               },
               function () {
                 forth.readLine("foo", this);
               },
               function () {
                 expect(forth.getStack()).toBe("1 65 2 <- Top ");
                 done();
               }
             ]);

             // Call keydown in a setTimeout to simulate waiting for keyboard input
             setTimeout(function () {
               expect(forth.getStack()).toBe("1 <- Top ");
               forth.keydown(65);
             }, 5);
           });

           it('calls output callback appropriately before and after key press', function (done) {
             var output = [];

             executeInSequence([
               function () {
                 forth.readLine(": foo  2 . key . 3 . ;", this);
               },
               function () {
                 forth.readLine("1 . foo 4 .", function (o) {
                   output.push(o);
                 }, this);
               },
               function () {
                 expect(output.join("")).toBe("1 2 65 3 4  ok");
                 done();
               }
             ]);

             // Call keydown in a setTimeout to simulate waiting for keyboard input
             setTimeout(function () {
               expect(output.join("")).toBe("1 2 ");
               forth.keydown(65);
             }, 5);
           });
         });

         describe('in loop', function () {
           it('calls output callback appropriately after each key press', function (done) {
             var output = [];

             executeInSequence([
               function () {
                 forth.readLine(": foo  2 . 3 0 do key . loop 3 . ;", this);
               },
               function () {
                 forth.readLine("1 . foo 4 .", function (o) {
                   output.push(o);
                 }, this);
               },
               function () {
                 expect(output.join("")).toBe("1 2 65 66 67 3 4  ok");
                 done();
               }
             ]);

             // Call keydown in a setTimeout to simulate waiting for keyboard input
             setTimeout(function () {
               expect(output.join("")).toBe("1 2 ");
               forth.keydown(65);

               setTimeout(function () {
                 expect(output.join("")).toBe("1 2 65 ");
                 forth.keydown(66);

                 setTimeout(function () {
                   expect(output.join("")).toBe("1 2 65 66 ");
                   forth.keydown(67);
                 }, 5);
               }, 5);
             }, 5);
           });
         });
       });

       describe('last-key', function () {
         it('stores the value of the last key pressed', function (done) {
           executeInSequence([
             function () {
               forth.readLine("last-key @", this);
             },
             function () {
               expect(forth.getStack()).toBe("0 <- Top ");

               forth.readLine("50 sleep last-key @", this);
             },
             function () {
               expect(forth.getStack()).toBe("0 32 <- Top ");
               done();
             }
           ]);

           setTimeout(function () {
             forth.keydown(32);
           }, 5);
         });
       });
     });

     describe('sleep', function () {
       it('pauses execution of line until key is pressed', function (done) {
         forth.readLine("1 50 sleep 2", function () {
           expect(forth.getStack()).toBe("1 2 <- Top ");
           done();
         });

         setTimeout(function () {
           expect(forth.getStack()).toBe("1 <- Top ");
         }, 5);
       });

       describe('in definition', function () {
         it('pauses execution of line until key is pressed', function (done) {
           executeInSequence([
             function () {
               forth.readLine(": foo  1 50 sleep 2 ;", this);
             },
             function () {
               forth.readLine("foo", this);
             },
             function () {
               expect(forth.getStack()).toBe("1 2 <- Top ");
               done();
             }
           ]);

           setTimeout(function () {
             expect(forth.getStack()).toBe("1 <- Top ");
           }, 5);
         });
       });
     });

     describe('control structures', function () {
       describe('if/else/then', function () {
         describe('with true condition', function () {
           it('executes consequent', function (done) {
             forth.readLines([
               ": foo  -1 if 1 else 2 then 3 ; ",
               "foo"
             ], function () {
               expect(forth.getStack()).toBe("1 3 <- Top ");
               done();
             });
           });
         });

         describe('with false condition', function () {
           it('executes alternative', function (done) {
             forth.readLines([
               ": foo  0 if 1 else 2 then 3 ; ",
               "foo"
             ], function () {
               expect(forth.getStack()).toBe("2 3 <- Top ");
               done();
             });
           });
         });

         describe('nested structures', function () {
           it('executes the correct parts', function (done) {
             forth.readLines([
               ": foo  0 if 0 else -1 if 1 else 2 then then ; ",
               "foo"
             ], function () {
               expect(forth.getStack()).toBe("1 <- Top ");
               done();
             });
           });

           describe('with output', function () {
             it('executes the correct parts with output', function (done) {
               executeInSequence([
                 function () {
                   forth.readLines([
                     ': foo  0 if ." if1 " 0 else ." else1 "',
                     '  -1 if ." if2 " 1 else ." else2 " 2 then then ; '
                   ], this);
                 }, function () {
                   collectOutput(forth.readLine, "foo", function (output) {
                     expect(forth.getStack()).toBe("1 <- Top ");
                     expect(output).toBe("else1 if2  ok");
                     done();
                   });
                 }
               ]);
             });
           });

           describe('complexly nested', function () {
             it('executes the correct parts', function (done) {
               // example from http://www.forth.com/starting-forth/sf4/sf4.html
               executeInSequence([
                 function () {
                   forth.readLines([
                     ': eggsize   dup  18 < if  ." reject "      else',
                     '            dup  21 < if  ." small "       else',
                     '            dup  24 < if  ." medium "      else',
                     '            dup  27 < if  ." large "       else',
                     '            dup  30 < if  ." extra large " else',
                     '                    ." error "',
                     '            then then then then then drop ;'
                   ], this);
                 },
                 function () {
                   collectOutput(forth.readLine, '23 eggsize', this);
                 },
                 function (output) {
                   expect(output).toBe("medium  ok");

                   collectOutput(forth.readLine, '29 eggsize', this);
                 },
                 function (output) {
                   expect(output).toBe("extra large  ok");

                   collectOutput(forth.readLine, '31 eggsize', this);
                 },
                 function (output) {
                   expect(output).toBe("error  ok");
                   expect(forth.getStack()).toBe(" <- Top ");
                   done();
                 }
               ]);
             });
           });
         });
       });

       describe('do/loop', function () {
         it('loops', function (done) {
           executeInSequence([
             function () {
               forth.readLine(': foo  4 0 do ." hello! " loop ; ', this);
             },
             function () {
               collectOutput(forth.readLine, "foo", this);
             },
             function (output) {
               expect(forth.getStack()).toBe(" <- Top ");
               expect(output).toBe("hello! hello! hello! hello!  ok");
               done();
             }
           ]);
         });

         it('loops, setting i to current index', function (done) {
           executeInSequence([
             function () {
               collectOutput(forth.readLine, ': foo  4 0 do ." hello! " i . loop ; ', this);
             },
             function (output) {
               expect(output).toBe(" ok");

               collectOutput(forth.readLine, "foo", this);
             },
             function (output) {
               expect(forth.getStack()).toBe(" <- Top ");
               expect(output).toBe("hello! 0 hello! 1 hello! 2 hello! 3  ok");
               done();
             }
           ]);
         });

         describe('nested loops', function () {
           it('loops, setting i and j to inner and outer indexes', function (done) {
             executeInSequence([
               function () {
                 forth.readLine(': foo  3 0 do 2 0 do i . j . ."  " loop loop ; ', this);
               },
               function () {
                 collectOutput(forth.readLine, "foo", this);
               },
               function (output) {
                 expect(forth.getStack()).toBe(" <- Top ");
                 expect(output).toBe("0 0  1 0  0 1  1 1  0 2  1 2   ok");
                 done();
               }
             ]);
           });
         });
       });

       describe('do/+loop', function () {
         it('loops', function (done) {
           executeInSequence([
             function () {
               forth.readLine(': foo  128 1 do i . i +loop ; ', this);
             },
             function () {
               collectOutput(forth.readLine, "foo", this);
             },
             function (output) {
               expect(forth.getStack()).toBe(" <- Top ");
               expect(output).toBe("1 2 4 8 16 32 64  ok");
               done();
             }
           ]);
         });
       });


         describe('begin/until', function () {
           it('loops', function (done) {
             executeInSequence([
               function () {
                 forth.readLine(': foo  10 begin dup . 1- dup 0= until drop ; ', this);
               },
               function () {
                 collectOutput(forth.readLine, "foo", this);
               },
               function (output) {
                 expect(forth.getStack()).toBe(" <- Top ");
                 expect(output).toBe("10 9 8 7 6 5 4 3 2 1  ok");
                 done();
               }
             ]);
           });
         });
       });

       describe('variables', function () {
         it('saves and retrieves values from different variables', function (done) {
           executeInSequence([
             function () {
               collectOutput(forth.readLine, 'variable foo', this);
             },
             function (output) {
               expect(output).toBe(" ok");

               forth.readLines([
                 'variable bar',
                 'foo bar'
               ], this);
             },
             function () {
               // this is testing an implementation detail, i.e. the particular memory addresses Memory uses
               expect(forth.getStack()).toBe("1577 1578 <- Top ");

               forth.readLine('drop drop 100 foo !  200 bar !', this);
             },
             function () {
               expect(forth.getStack()).toBe(" <- Top ");

               forth.readLine('foo @  bar @', this);
             },
             function () {
               expect(forth.getStack()).toBe("100 200 <- Top ");

               forth.readLines([
                 '5 cells allot',
                 'variable baz',
                 'baz'
               ], this);
             },
             function () {
               expect(forth.getStack()).toBe("100 200 1584 <- Top ");
               done();
             }
           ]);
         });
       });

       describe('constants', function () {
         it('sets values in constants', function (done) {
           executeInSequence([
             function () {
               collectOutput(forth.readLine, '10 constant foo', this);
             },
             function (output) {
               expect(output).toBe(" ok");

               forth.readLines([
                 '20 constant bar',
                 'foo bar'
               ], this);
             },
             function () {
               expect(forth.getStack()).toBe("10 20 <- Top ");
               done();
             }
           ]);
         });
       });
     });


     */


}
