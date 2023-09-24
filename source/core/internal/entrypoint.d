module core.internal.entrypoint;

template _d_cmain() {
    import core.stdc.stdlib;
    import core.stdc.string;

    extern(C) {
        int _d_run_main(int argc, char **argv, void* mainFunc) {
            // This is only meant to be used on SuperH with elf,
            // We can be pretty sure that the input string will be
            // at least ascii.

            char[][] args = (cast(char[]*)alloca(argc * (char[]).sizeof))[0..argc];
            size_t totalArgsLength = 0;
            foreach (i, ref arg; args) {
                arg = argv[i][0 .. strlen(argv[i])];
                totalArgsLength += arg.length;
            }

            // We will do no cleanup either, if things break then too bad.
            // TODO: maybe add libunwind support?
            return (cast(int function(char[][]))mainFunc)(args);
        }

        int _Dmain(char[][] args);

        int main(int argc, char **argv) {
            return _d_run_main(argc, argv, &_Dmain);
        }
    }
}

// Because this is compiled without phobos
// We need to invoke it outselves. 
mixin _d_cmain;