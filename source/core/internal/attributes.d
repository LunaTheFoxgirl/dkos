module core.internal.attributes;

/**
Used to annotate `unittest`s which need to be tested in a `-betterC` environment.

Such `unittest`s will be compiled and executed without linking druntime in, with
a `__traits(getUnitTests, mixin(__MODULE__))` style test runner.
Note that just like any other `unittest` in druntime, they will also be compiled
and executed without `-betterC`.
*/
package(core) enum betterC = 1;

// Basic GCC attribute shenanigans

private struct Attribute(A...) {
    A arguments;
}

@system
auto attribute(A...)(A arguments) if (A.length > 0 && is(A[0] == string)) {
    return Attribute!A(arguments);
}

auto section(string sectionName) {
    return attribute("section", sectionName);
}

enum used = attribute("used");