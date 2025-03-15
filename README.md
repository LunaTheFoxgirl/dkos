# KallistiOS for D
This library provides the core APIs of the KallistiOS development environment for
the SEGA Dreamcast, a GDC SH4 cross compiler is required for dreamcast development.
It is also recommended to have LDC2 installed on your system if you wish to target
the VMU.

You will need a `sh-elf-gdc` toolchain, which can be built with the dc-chain script
provided by `dc-chain` in the KallistiOS repository.

## Sub-configurations
DKOS can be used to develop for the SEGA Dreamcast, it's arcade counterpart; the
Naomi, and the Dreamcast's VMUs. To specify which platform you're targeting use
the subConfiguration dub tag.

For example; to target the SEGA Naomi add the following to your dub.sdl:
```
subConfiguration "dkos" "naomi"
```

The following configurations are defined:
 * `dreamcast` - targeting the SEGA Dreamcast
 * `naomi` - targeting the SEGA Naomi
 * `vmu` - targeting the VMU (LDC2 needed!)

## Known issues and TODOs
None of the documentation have been converted to DDOC format as of current,
this is a priority. Additionally only a small subset of the KOS APIs are 
currently implemented.

A patch to dc-chain is also in the works, as a specific setup regarding the
libphobos sources are needed. ([PR](https://github.com/KallistiOS/KallistiOS/pull/954)).