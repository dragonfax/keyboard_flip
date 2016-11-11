### Keyboard Flip

Using the space key as a modifier key to flip the keyboard right to left.

While running this command, you can flip the whole keyboard on demand, allowing you to type the right side of the keyboard on its left side.  This allows for one-handed typing.

This is sometimes referred to as Half-Qwerty or Mirror-Keyboard.

While this command is running it intercepts **all** input from the keyboard and modifies it, only while you are holding down the SPACE key.  Otherwise your keyboard will act normally.  To deactive it, simply stop the program. (ctrl-C)

### Build && Use

Execute the following in terminal to compile and execute the tool.

    clang -framework Foundation -framework coregraphics keyboard_flip.m

    sudo ./a.out

### Learning

Half-Qwerty takes a little time to learn but not as long as you expect. Your right hand already knows how to type as if it was your left, and vice versa. Its just not used to doing so. Just give it a try, and you'll find the knowledge is already half-there.

### Source

This is my very first bit of Objective C.
