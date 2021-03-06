{-# LANGUAGE FlexibleContexts, TypeFamilies #-}
module Shade.Core.Internal.Core where
import Control.Applicative (Applicative)
import Data.String (IsString)
import qualified Shade.Core.Internal.Attributes as A
import qualified Shade.Core.Internal.Events as E
import Prelude hiding (div)

type Attrs s a = [a ((NativeString s), A.AttrValue (NativeString s))]

class ToString a where
  toString :: a -> String

class ( Applicative s
      , Monad s
      , Functor   (Async s)
      , FireFirst (Async s)
      , ToString (NativeString s)
      , IsString (NativeString s)
      ) => Shade s where
  type Async s :: * -> *
  type NativeString s :: *
  type NativeElem s :: *
  data ElemAsyncs s :: *
  button  :: Attrs s A.ButtonAttr   -> s a -> s (ElemAsyncs s)
  div     :: Attrs s A.DivAttr      -> s a -> s (ElemAsyncs s)
  header  :: Attrs s A.HeaderAttr   -> s a -> s (ElemAsyncs s)
  h1      :: Attrs s A.H1Attr       -> s a -> s (ElemAsyncs s)
  section :: Attrs s A.SectionAttr  -> s a -> s (ElemAsyncs s)
  ul      :: Attrs s A.UlAttr       -> s a -> s (ElemAsyncs s)
  li      :: Attrs s A.LiAttr       -> s a -> s (ElemAsyncs s)
  label   :: Attrs s A.LabelAttr    -> s a -> s (ElemAsyncs s)
  footer  :: Attrs s A.FooterAttr   -> s a -> s (ElemAsyncs s)
  span    :: Attrs s A.SpanAttr     -> s a -> s (ElemAsyncs s)
  strong  :: Attrs s A.StrongAttr   -> s a -> s (ElemAsyncs s)
  a       :: Attrs s A.AAttr        -> s a -> s (ElemAsyncs s)
  input   :: Attrs s A.InputAttr           -> s (ElemAsyncs s)
  text    :: String                        -> s ()
  letElt  :: s a -> s (a , s a)
  onClick       :: ElemAsyncs s -> Async s (E.MouseEvent    (NativeElem s))
  onDoubleClick :: ElemAsyncs s -> Async s (E.MouseEvent    (NativeElem s))
  onChange      :: ElemAsyncs s -> Async s (E.ChangeEvent   (NativeString s))
  onKeyUp       :: ElemAsyncs s -> Async s (E.KeyboardEvent (NativeElem s))
  onKeyPress    :: ElemAsyncs s -> Async s (E.KeyboardEvent (NativeElem s))
  onKeyDown     :: ElemAsyncs s -> Async s (E.KeyboardEvent (NativeElem s))
  onBlur        :: ElemAsyncs s -> Async s (E.FocusEvent    (NativeElem s))
  domElements   :: ElemAsyncs s -> IO [NativeElem s] -- TODO Make an async too, on componentDidMount etc. (need to hook into component lifecycle stuff)

class FireFirst a where
  fireFirst  :: [a b] -> a b -- Meant in the monoid mconcat sense
