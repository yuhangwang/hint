module Language.Haskell.Interpreter.Unsafe (
    unsafeSetGhcOption, unsafeRunInterpreterWithArgs, unsafeRunInterpreterWithArgsLibdir,
    unsafeInterpret
) where

import Control.Monad.Trans
import Control.Monad.Catch

import Hint.Base
import Hint.Eval
import Hint.Configuration
import Hint.InterpreterT

-- | Set a GHC option for the current session,
--   eg. @unsafeSetGhcOption \"-XNoMonomorphismRestriction\"@.
--
--   Warning: Some options may interact badly with the Interpreter.
unsafeSetGhcOption :: MonadInterpreter m => String -> m ()
unsafeSetGhcOption = setGhcOption

-- | Executes the interpreter, setting the args as though they were
--   command-line args.  In particular, this means args that have no
--   effect with :set in ghci might function properly from this
--   context.
--
--   Warning: Some options may interact badly with the Interpreter.
unsafeRunInterpreterWithArgs :: (MonadMask m, MonadIO m
#if __GLASGOW_HASKELL__ < 800
                                 , Functor m
#endif
                             ) => [String]
                             -> InterpreterT m a
                             -> m (Either InterpreterError a)
unsafeRunInterpreterWithArgs = runInterpreterWithArgs

-- | A variant of @unsafeRunInterpreterWithArgs@ which also lets you
--   specify the folder in which the GHC bootstrap libraries (base,
--   containers, etc.) can be found. This allows you to run hint on
--   a machine in which GHC is not installed.
--
--   A typical libdir value would be "/opt/ghc/7.10.3/lib/ghc-7.10.3".
unsafeRunInterpreterWithArgsLibdir :: (MonadIO m, MonadMask m
#if __GLASGOW_HASKELL__ < 800
                                 , Functor m
#endif
                                   ) => [String]
                                   -> String
                                   -> InterpreterT m a
                                   -> m (Either InterpreterError a)
unsafeRunInterpreterWithArgsLibdir = runInterpreterWithArgsLibdir
