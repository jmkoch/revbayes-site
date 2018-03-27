#Guidelines for testing new implementations in RevBayes

Overall rules/guidelines for testing: 

Run it in rev script
Compare to R output

→ do this by making a testing rev script with your command in it (named ‘test_script.rev’)
fnBiChrom(10,1,2,3,4,5,6,7,8,9,10) 

(lldb is the debugger within Eclipse ; llvc is the compiler)

So do this in the terminal: 

$ lldb ./rb test_script.rev  
$ target create “./rb”
$ settings set -- target.run-args “test_script.rev”
$ run

//now need to add a break point (to tell RB where to look for the error you’re facing):

$ break set --file RbVectorImpl.h --line 77     (fill in the filename and line number yourself)

//Now test it again 

$ r (or run)  //this reruns your code. It will prompt if you want to kill & restart→ say yes
$ bt  (or backtrace) //This will retrace through the file how it’s running & show you line numbers where it’s trying to run/do what you’ve coded. 

//If it’s not very in depth yet, you can run the following command:

$ frame select 1 //or anywhere
$ print i  //print any variables in the scope of this spot 
$ print j   (print whatever you want to look at from your respective code)

$ q //this quits the debugger

Google lldb for overall cheatsheet on the debugger - it’s a powerful tool!! 


Testing MCMC behavior is entirely separate from testing distributions & functions; this is where the validation comes in to play; for this just write rules for testing functions/distributions.

To make sure the actual output is correct, that’s where we need validation. 


Add rb to path: make a sym link

$ ln -s /.../projects/cmake/rb /usr/local/rb   (first arg: where rb is located; second arg: where u want it)

$ hash -r  (reloads path)
//or on linux machine, use $ rehash

IF it looks weird, rebuild revBayes with the debugger (will need to rebuild everything)
→ Project > Build Configurations > Set Active (Check that it’s on ‘Debug’). 
If it is on Debug but still looks weird, go further within your project to make sure it’s really set on: 

Project > Properties > C/C++ Build > Behavior tab > make sure ‘-debug true’ (then click Apply & close)
