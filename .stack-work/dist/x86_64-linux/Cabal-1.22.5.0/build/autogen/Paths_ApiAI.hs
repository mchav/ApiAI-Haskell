module Paths_ApiAI (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/chav/Code/Haskell/ApiAI-Haskell/.stack-work/install/x86_64-linux/lts-5.6/7.10.3/bin"
libdir     = "/home/chav/Code/Haskell/ApiAI-Haskell/.stack-work/install/x86_64-linux/lts-5.6/7.10.3/lib/x86_64-linux-ghc-7.10.3/ApiAI-0.1.0.0-C9EeJKrUwqqKkAaKNcavOS"
datadir    = "/home/chav/Code/Haskell/ApiAI-Haskell/.stack-work/install/x86_64-linux/lts-5.6/7.10.3/share/x86_64-linux-ghc-7.10.3/ApiAI-0.1.0.0"
libexecdir = "/home/chav/.cabal/libexec"
sysconfdir = "/home/chav/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "ApiAI_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "ApiAI_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "ApiAI_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "ApiAI_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "ApiAI_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
