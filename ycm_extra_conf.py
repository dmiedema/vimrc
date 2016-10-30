import os
import ycm_core

flags = [
'-Wall',        # Enable all warnings
'-Wextra',      # Enable extra warnings
'-Wno-unused-parameter',
'-resource-dir',
'/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../lib/clang/6.0',
'-isysroot',
'/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk',
'-F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks'
'-I/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/include',
'-fblocks',
'-fobjc-runtime=ios-10.1.0',
'-fencode-extended-block-signature',
'-fobjc-arc',
'-fobjc-exceptions',
'-fexceptions',
'-x',
'objective-c'
]

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

def FlagsForFile( filename, **kwargs ):
  return {
    'flags': flags,
    'do_cache': True
  }
