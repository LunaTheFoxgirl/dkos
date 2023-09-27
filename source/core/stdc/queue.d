/**
    Implementation of sys/queue for D.

    TODO: Add functions to allow easy iteration
*/
module core.stdc.queue;

struct QHead(T) {
    T* first;
    T** last;
}

struct QEntry(T) {
    T* next;
    T** prev;
}