import XCTest
@testable import StepForth

class CoreTests: XCTestCase {

    let forth = Forth()

    /* Should add numbers on the stack */
    func testMathAdd() throws {
        ReadLine(forth, "10")
        StackShouldEqual(forth, "10 <- Top ")

        ReadLine(forth, "3 4 +")
        StackShouldEqual(forth, "10 7 <- Top ")

        ReadLine(forth, "+")
        StackShouldEqual(forth, "17 <- Top ")
    }

    /* Should multiply numbers on the stack */
    func testMathMultiply() throws {
        ReadLine(forth, "10")
        ReadLine(forth, "22 4 *")
        StackShouldEqual(forth, "10 88 <- Top ")
    }
}

/*

 describe('predefined words', function () {
   describe('arithmetic', function () {
     describe('/', function () {
       it('divides numbers on the stack', function (done) {
         executeInSequence([
           function () {
             forth.readLine("10", this);
           },
           function () {
             forth.readLine("22 4 /", this);
           },
           function () {
             expect(forth.getStack()).toBe("10 5 <- Top ");
             done();
           }
         ]);
       });
     });

     describe('mod', function () {
       it('mods numbers on the stack', function (done) {
         executeInSequence([
           function () {
             forth.readLine("10", this);
           },
           function () {
             forth.readLine("22 4 mod", this);
           },
           function () {
             expect(forth.getStack()).toBe("10 2 <- Top ");
             done();
           }
         ]);
       });
     });

     describe('/mod', function () {
       it('mods and divides numbers on the stack', function (done) {
         forth.readLines([
           "10",
           "22 4 /mod"
         ], function () {
           expect(forth.getStack()).toBe("10 2 5 <- Top ");
           done();
         });
       });
     });
   });

   describe('comparison', function () {
     describe('=', function () {
       it('compares numbers on the stack for equality', function (done) {
         executeInSequence([
           function () {
             forth.readLines([
               "10",
               "5 5 ="
             ], this);
           },
           function () {
             expect(forth.getStack()).toBe("10 -1 <- Top ");

             forth.readLine("4 5 =", this);
           },
           function () {
             expect(forth.getStack()).toBe("10 -1 0 <- Top ");
             done();
           }
         ]);
       });
     });

     describe('<', function () {
       it('checks to see if second item is less than top item on stack', function (done) {
         executeInSequence([
           function () {
             forth.readLines([
               "10",
               "5 4 <"
             ], this);
           },
           function () {
             expect(forth.getStack()).toBe("10 0 <- Top ");

             forth.readLine("4 5 <", function () {
               expect(forth.getStack()).toBe("10 0 -1 <- Top ");
               done();
             });
           }
         ]);
       });
     });

     describe('>', function () {
       it('checks to see if second item is more than top item on stack', function (done) {
         executeInSequence([
           function () {
             forth.readLines([
               "10",
               "5 4 >"
             ], this);
           },
           function () {
             expect(forth.getStack()).toBe("10 -1 <- Top ");

             forth.readLine("4 5 >", function () {
               expect(forth.getStack()).toBe("10 -1 0 <- Top ");
               done();
             });
           }
         ]);
       });
     });
   });

   describe('stack manipulation', function () {
     describe('swap', function () {
       it('swaps the top two items', function (done) {
         executeInSequence([
           function () {
             forth.readLine("10 5", this);
           },
           function () {
             expect(forth.getStack()).toBe("10 5 <- Top ");

             forth.readLine("swap", function () {
               expect(forth.getStack()).toBe("5 10 <- Top ");
               done();
             });
           }
         ]);
       });
     });

     describe('dup', function () {
       it('duplicates the top item', function (done) {
         executeInSequence([
           function () {
             forth.readLine("10 5", this);
           },
           function () {
             expect(forth.getStack()).toBe("10 5 <- Top ");

             forth.readLine("dup", function () {
               expect(forth.getStack()).toBe("10 5 5 <- Top ");
               done();
             });
           }
         ]);
       });
     });

     describe('over', function () {
       it('copies the second item to the top', function (done) {
         executeInSequence([
           function () {
             forth.readLine("10 5", this);
           },
           function () {
             expect(forth.getStack()).toBe("10 5 <- Top ");

             forth.readLine("over", function () {
               expect(forth.getStack()).toBe("10 5 10 <- Top ");
               done();
             });
           }
         ]);
       });
     });

     describe('rot', function () {
       it('rotates the top three items', function (done) {
         executeInSequence([
           function () {
             forth.readLine("1 2 3", this);
           },
           function () {
             expect(forth.getStack()).toBe("1 2 3 <- Top ");

             forth.readLine("rot", function () {
               expect(forth.getStack()).toBe("2 3 1 <- Top ");
               done();
             });
           }
         ]);
       });
     });

     describe('drop', function () {
       it('drops the top item', function (done) {
         executeInSequence([
           function () {
             forth.readLine("1 2 3", this);
           },
           function () {
             expect(forth.getStack()).toBe("1 2 3 <- Top ");

             forth.readLine("drop", function () {
               expect(forth.getStack()).toBe("1 2 <- Top ");
               done();
             });
           }
         ]);
       });
     });
   });

   describe('output', function () {
     describe('.', function () {
       it('pops and outputs the top of the stack as a number', function (done) {
         collectOutput(forth.readLine, "1 2 3 .", function (output) {
           expect(forth.getStack()).toBe("1 2 <- Top ");
           expect(output).toBe("3  ok");
           done();
         });
       });
     });

     describe('.s', function () {
       it('outputs the contents of the stack', function (done) {
         collectOutput(forth.readLine, "1 2 3 .s", function (output) {
           expect(forth.getStack()).toBe("1 2 3 <- Top ");
           expect(output).toBe("\n1 2 3 <- Top  ok");
           done();
         });
       });
     });

     describe('cr', function () {
       it('outputs a newline', function (done) {
         collectOutput(forth.readLine, "1 2 . cr .", function (output) {
           expect(forth.getStack()).toBe(" <- Top ");
           expect(output).toBe("2 \n1  ok");
           done();
         });
       });
     });

     describe('space', function () {
       it('outputs a space', function (done) {
         collectOutput(forth.readLine, "1 2 . space space .", function (output) {
           expect(forth.getStack()).toBe(" <- Top ");
           expect(output).toBe("2   1  ok");
           done();
         });
       });
     });

     describe('spaces', function () {
       it('outputs n (top of stack) spaces', function (done) {
         collectOutput(forth.readLine, "1 2 . 5 spaces .", function (output) {
           expect(forth.getStack()).toBe(" <- Top ");
           expect(output).toBe("2      1  ok");
           done();
         });
       });
     });

     describe('emit', function () {
       it('outputs top of stack as ascii character', function (done) {
         executeInSequence([
           function () {
             collectOutput(forth.readLine, "99 emit", this);
           },
           function (output) {
             expect(forth.getStack()).toBe(" <- Top ");
             expect(output).toBe("c ok");

             collectOutput(forth.readLine, "108 111 111 99 emit emit emit emit", this)
           },
           function (output) {
             expect(forth.getStack()).toBe(" <- Top ");
             expect(output).toBe("cool ok");
             done();
           }
         ]);
       });
     });
   });

 */
