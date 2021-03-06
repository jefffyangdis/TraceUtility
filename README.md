在原工程基础上添加了Allocations内存采样统计功能
https://testerhome.com/topics/4512

# TraceUtility

*Works with Instruments.app bundled in Xcode 9.4*

*[Blog post](https://qusic.me/post/extract-data-from-trace-documents/) (in Chinese 中文)*

A proof of concept on how to extract data from .trace documents generated by Instruments, using the undocumented frameworks shipped with Instruments.

We need to link against these frameworks:

* `/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework`
* `/Applications/Xcode.app/Contents/SharedFrameworks/DVTInstrumentsFoundation.framework`
* `/Applications/Xcode.app/Contents/SharedFrameworks/DVTInstrumentsUtilities.framework`
* `/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/Frameworks/InstrumentsPlugIn.framework`
* `/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/Frameworks/InstrumentsKit.framework`
* `/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/Frameworks/InstrumentsAnalysisCore.framework`

Instrument templates used by the app are packages in `/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/Packages` and plugins in `/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns`.

It seems Apple is migrating from `PlugIns` to `Packages`. For example, the instrument `Time Profile` in `PlugIns/SamplerPlugin.xrplugin` is deprecated in Xcode 8 and there is a new version in `Packages/Sampling.instrdst`.

This project contains these example routines:

* **Time Profiler**: print out all functions in descending order of self execution time.
* **Allocations**: print out the memory allocated during each second in descending order of the size.
* **Core Animation**: print out all FPS data samples.
* **Connections**: print out connection history with protocol, addresses and bytes transferred.

They are not all of the templates included in Instruments. However, it is well enough to demonstrate how to work with the data in several common structures, such as call trees, tables and streams.

Here is a sample output.

```
Trace: /Users/qusic/Downloads/Instruments.trace
Device: Q's (10.3.1) (iPhone9,1 10.3.1 14E304)
Process: Playground (me.qusic.Playground)

Instrument: Time Profiler (com.apple.xray.instrument-type.coresampler2)
Run #2: Run 2
libobjc.A.dylib flushCaches(objc_class*) 25 ms
libobjc.A.dylib cache_erase_nolock 18 ms
libobjc.A.dylib std::__1::__function::__func<void (objc_class*) block_pointer, std::__1::allocator<void (objc_class*) block_pointer>, void (objc_class*)>::operator()(objc_class*&&) 7 ms
dyld __open 4 ms
dyld __mmap 3 ms
libsystem_platform.dylib OSAtomicDequeue 3 ms
libobjc.A.dylib std::__1::__function::__func<foreach_realized_class_and_metaclass(std::__1::function<void (objc_class*)>)::'lambda'(objc_class*), std::__1::allocator<foreach_realized_class_and_metaclass(std::__1::function<void (objc_class*)>)::'lambda'(objc_class*)>, bool (objc_class*)>::operator()(objc_class*&&) 3 ms
dyld getattrlist 2 ms
dyld stat64 2 ms
libobjc.A.dylib realizeClass(objc_class*) 2 ms
libobjc.A.dylib ___ZL11flushCachesP10objc_class_block_invoke_2 2 ms
dyld ImageLoaderMachOCompressed::eachBind(ImageLoader::LinkContext const&, unsigned long (ImageLoaderMachOCompressed::*)(ImageLoader::LinkContext const&, unsigned long, unsigned char, char const*, unsigned char, long, long, char const*, ImageLoaderMachOCompressed::LastLookup*, bool)) 2 ms
dyld ImageLoaderMachOCompressed::interposeAt(ImageLoader::LinkContext const&, unsigned long, unsigned char, char const*, unsigned char, long, long, char const*, ImageLoaderMachOCompressed::LastLookup*, bool) 2 ms
liboainject.dylib 0x10009806c 1 ms
libsystem_c.dylib _thread_stack_pcs 1 ms
libsystem_kernel.dylib __ulock_wake 1 ms
libsystem_platform.dylib _platform_strcmp 1 ms
libsystem_kernel.dylib __open 1 ms
libsystem_kernel.dylib stat 1 ms
libobjc.A.dylib rwlock_tt<false>::read() 1 ms
libsystem_platform.dylib _platform_memmove 1 ms
libsystem_kernel.dylib __ulock_wait 1 ms
libsystem_platform.dylib os_unfair_lock_lock 1 ms
libsystem_kernel.dylib _kernelrpc_mach_port_mod_refs_trap 1 ms
libsystem_platform.dylib _platform_memmove 1 ms
libsystem_pthread.dylib pthread_rwlock_unlock 1 ms
libxpc.dylib xpc_pipe_routine 1 ms
libsystem_c.dylib _thread_stack_pcs 1 ms
libsystem_platform.dylib OSAtomicDequeue 1 ms
libobjc.A.dylib search_method_list(method_list_t const*, objc_selector*) 1 ms
liboainject.dylib 0x10009b064 1 ms
// Truncated for brevity

Instrument: Allocations (com.apple.xray.instrument-type.oa)
Run #2: Run 2
1 2.8 MB
6 1.5 MB
36 768 KB
31 385 KB
33 384 KB
25 214 KB
27 209 KB
26 105 KB
2 2 KB
28 400 bytes

Instrument: Core Animation (com.apple.dt.coreanimation-fps)
Run #2: Run 2
00:00.000.000  0 FPS 34.0% GPU
00:00.001.148  4 FPS 36.0% GPU
00:01.008.767  0 FPS  0.0% GPU
00:02.017.394  4 FPS  0.0% GPU
00:03.307.257 52 FPS 49.0% GPU
00:04.466.874 59 FPS 34.0% GPU
00:05.470.818 60 FPS 35.0% GPU
00:06.481.732 59 FPS 38.0% GPU
00:07.487.501 54 FPS 10.0% GPU
00:08.493.927 26 FPS 54.0% GPU
00:09.724.195 20 FPS 38.0% GPU
00:10.846.081 57 FPS 31.0% GPU
00:11.854.797 24 FPS  8.0% GPU

Instrument: Connections (com.apple.dt.network-connections)
Run #2: Run 2
Wi-Fi tcp4 xxx:xxx<->xxx:xxx, 0 Bytes in, 64 Bytes out
Wi-Fi tcp4 xxx:xxx<->xxx:xxx, 0 Bytes in, 0 Bytes out
Wi-Fi upd4 xxx:xxx<->xxx:xxx, 227 Bytes in, 35 Bytes out
Wi-Fi tcp4 xxx:xxx<->xxx:xxx, 744 Bytes in, 0 Bytes out
```
