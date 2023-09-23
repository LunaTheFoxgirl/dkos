module core.internal.entrypoint;

import newlib.stdlib;

template _d_cmain() {
    extern(C) {
        int _d_run_main(int argc, char **argv, void* mainFunc) {
            // This is only meant to be used on SuperH with elf,
            // We can be pretty sure that the input string will be
            // at least ascii.

            char[][] args = alloca(argc * (char[]).sizeof)[0..argc];
            size_t totalArgsLength = 0;
            foreach (i, ref arg; args) {
                arg = argv[i][0 .. strlen(argv[i])];
                totalArgsLength += arg.length;
            }

            // We will do no cleanup either, if things break then too bad.
            // TODO: maybe add libunwind support?
            return mainFunc(args);
        }

        int _Dmain(char[][] args);

        int main(int argc, char **argv) {
            return _d_run_main(argc, argv, &_Dmain);
        }
    }
}