{-# LINE 1 "src/System/InputDevice.hsc" #-}
module System.InputDevice
    ( InputDevice (..)
    , InputDeviceGroup (..)
    , getInputDeviceGroup

    , AccelProfile (..)
    , ClickMethod (..)
    , ConfigStatus (..)
    , DWTState (..)
    , DragLockState (..)
    , DragState (..)
    , MiddleEmulationState (..)
    , ScrollMethod (..)
    , SendEventsMode (..)
    , TapButtonMap (..)
    , TapState (..)

    , statusToText
    , getDefaultAccelProfile
    , getDefaultAccelSpeed
    , getAccelProfile
    , getAccelProfiles
    , getAccelSpeed
    , isAccelAvailable
    , setAccelProfile
    , setAccelSpeed

    -- TODO: These should really have a better matrix type
    , getCalibrationDefaultMatrix
    , getCalibrationMatrix
    , hasCalibrationMatrix
    , setCalibrationMatrix

    , getClickDefaultMethod
    , getClickMethod
    , getClickMethods
    , setClickMethod

    , getDWTDefaultEnabled
    , getDWTEnabled
    , isDWTAvailable
    , setDWTEnabled

    , getDefaultLeftHanded
    , getLeftHanded
    , isLeftHandledAvailable
    , setLeftHanded

    , getMiddleEmulationDefaultEnabled
    , getMiddleEmulationEnabled
    , isMiddleEmulationAvailable
    , setMiddleEmulationEnabled

    , getRotationDefaultAngle
    , getRotationAngle
    , isRotationAvailable
    , setRotationDefaultAngle

    , getScrollDefaultButton
    , getScrollButton
    , setScrollButton

    , getScrollDefaultMethod
    , getScrollMethod
    , getScrollMethods
    , setScrollMethod

    , getNaturalScrollDefaultEnabled
    , getNaturalScrollEnabled
    , hasNaturalScroll
    , setNaturalScrollenabled

    , getSendEventsDefaultMode
    , getSendEventsMode
    , getSendEventsModes
    , setSendEventsMode

    , getTapDefaultButtonMap
    , getTapButtonMap
    , setTapButtonMap

    , getTapDefaultDragEnabled
    , getTapDragEnabled
    , setTapDragEnabled

    , getTapDefaultDragLockEnabled
    , getTapDragLockEnabled
    , setTapDragLockEnabled

    , getTapDefaultEnabled
    , getTapEnabled
    , setTapEnabled
    , getTapFingerCount

    , getDeviceSysname
    , getDeviceName
    , getDeviceVendor
    , getDeviceProduct
    )
where



import Data.Bits ((.&.), (.|.))
import Data.ByteString.Unsafe (unsafePackCString)
import Data.Text (Text)
import Data.Word (Word32)
import Foreign.C.Error (throwErrnoIfNull)
import Foreign.C.String (CString)
import Foreign.C.Types (CUInt (..), CInt (..))
import Foreign.Marshal.Alloc
import Foreign.Ptr (Ptr, nullPtr)
import Foreign.Storable

import qualified Data.Text as T
import qualified Data.Text.Encoding as E

newtype InputDevice = InputDevice { unID :: Ptr InputDevice} deriving (Eq, Show)
newtype InputDeviceGroup = InputDeviceGroup (Ptr InputDeviceGroup) deriving (Eq, Show)

foreign import ccall unsafe "libinput_device_get_device_group" c_get_device_group :: Ptr InputDevice -> IO (Ptr InputDeviceGroup)

getInputDeviceGroup :: InputDevice -> IO InputDeviceGroup
getInputDeviceGroup (InputDevice ptr) =
    InputDeviceGroup <$> throwErrnoIfNull "getInputDeviceGroup" (c_get_device_group ptr)


foreign import ccall unsafe "libinput_device_get_sysname" c_get_sysname :: Ptr InputDevice -> IO CString

getDeviceSysname :: InputDevice -> IO Text
getDeviceSysname (InputDevice dev) = fmap E.decodeUtf8 . unsafePackCString =<< c_get_sysname dev

foreign import ccall unsafe "libinput_device_get_name" c_get_name :: Ptr InputDevice -> IO CString

getDeviceName :: InputDevice -> IO Text
getDeviceName (InputDevice dev) = fmap E.decodeUtf8 . unsafePackCString =<< c_get_name dev

foreign import ccall unsafe "libinput_device_get_id_product" c_get_product :: Ptr InputDevice -> IO CInt

getDeviceProduct :: InputDevice -> IO Int
getDeviceProduct = fmap fromIntegral . c_get_product . unID


foreign import ccall unsafe "libinput_device_get_id_vendor" c_get_vendor :: Ptr InputDevice -> IO CInt

getDeviceVendor :: InputDevice -> IO Int
getDeviceVendor = fmap fromIntegral . c_get_vendor . unID


data AccelProfile
    = AccelProfileNone
    | AccelProfileFlat
    | AccelProfileAdaptive
    deriving (Eq, Show, Read)

accelProfileToInt :: Num a => AccelProfile -> a
accelProfileToInt AccelProfileNone     = 0
{-# LINE 158 "src/System/InputDevice.hsc" #-}
accelProfileToInt AccelProfileFlat     = 1
{-# LINE 159 "src/System/InputDevice.hsc" #-}
accelProfileToInt AccelProfileAdaptive = 2
{-# LINE 160 "src/System/InputDevice.hsc" #-}

intToAccelProfile :: (Eq a, Num a) => a -> AccelProfile
intToAccelProfile 0 = AccelProfileNone
{-# LINE 163 "src/System/InputDevice.hsc" #-}
intToAccelProfile 1 = AccelProfileFlat
{-# LINE 164 "src/System/InputDevice.hsc" #-}
intToAccelProfile 2 = AccelProfileAdaptive
{-# LINE 165 "src/System/InputDevice.hsc" #-}


data ClickMethod
    = ClickMethodNone
    | ClickMethodButtonAreas
    | ClickMethodClickFinger
    deriving (Eq, Show, Read)

clickMethodToInt :: Num a => ClickMethod -> a
clickMethodToInt ClickMethodNone        = 0
{-# LINE 175 "src/System/InputDevice.hsc" #-}
clickMethodToInt ClickMethodButtonAreas = 1
{-# LINE 176 "src/System/InputDevice.hsc" #-}
clickMethodToInt ClickMethodClickFinger = 2
{-# LINE 177 "src/System/InputDevice.hsc" #-}

intToClickMethod :: (Eq a, Num a) => a -> ClickMethod
intToClickMethod 0         = ClickMethodNone
{-# LINE 180 "src/System/InputDevice.hsc" #-}
intToClickMethod 1 = ClickMethodButtonAreas
{-# LINE 181 "src/System/InputDevice.hsc" #-}
intToClickMethod 2  = ClickMethodClickFinger
{-# LINE 182 "src/System/InputDevice.hsc" #-}


data DragLockState
    = DragLockDisabled
    | DragLockEnabled
    deriving (Eq, Show, Read)

dragLockStateToInt :: Num a => DragLockState -> a
dragLockStateToInt DragLockDisabled = 0
{-# LINE 191 "src/System/InputDevice.hsc" #-}
dragLockStateToInt DragLockEnabled  = 1
{-# LINE 192 "src/System/InputDevice.hsc" #-}

intToDragLockState :: (Eq a, Num a) => a -> DragLockState
intToDragLockState 0 = DragLockDisabled
{-# LINE 195 "src/System/InputDevice.hsc" #-}
intToDragLockState 1  = DragLockEnabled
{-# LINE 196 "src/System/InputDevice.hsc" #-}


data DragState
    = DragDisabled
    | DragEnabled
    deriving (Eq, Show, Read)

dragStateToInt :: Num a => DragState -> a
dragStateToInt DragDisabled = 0
{-# LINE 205 "src/System/InputDevice.hsc" #-}
dragStateToInt DragEnabled  = 1
{-# LINE 206 "src/System/InputDevice.hsc" #-}

intToDragState :: (Eq a, Num a) => a -> DragState
intToDragState 0 = DragDisabled
{-# LINE 209 "src/System/InputDevice.hsc" #-}
intToDragState 1  = DragEnabled
{-# LINE 210 "src/System/InputDevice.hsc" #-}


data DWTState
    = DWTDisabled
    | DWTEnabled
    deriving (Eq, Show, Read)

dwtStateToInt :: Num a => DWTState -> a
dwtStateToInt DWTDisabled = 0
{-# LINE 219 "src/System/InputDevice.hsc" #-}
dwtStateToInt DWTEnabled  = 1
{-# LINE 220 "src/System/InputDevice.hsc" #-}

intToDWTState :: (Eq a, Num a) => a -> DWTState
intToDWTState 0 = DWTDisabled
{-# LINE 223 "src/System/InputDevice.hsc" #-}
intToDWTState 1  = DWTEnabled
{-# LINE 224 "src/System/InputDevice.hsc" #-}


data MiddleEmulationState
    = MiddleEmulationDisabled
    | MiddleEmulationEnabled
    deriving (Eq, Show, Read)

middleEmulationToInt :: Num a => MiddleEmulationState -> a
middleEmulationToInt MiddleEmulationDisabled = 0
{-# LINE 233 "src/System/InputDevice.hsc" #-}
middleEmulationToInt MiddleEmulationEnabled  = 1
{-# LINE 234 "src/System/InputDevice.hsc" #-}

intToMiddleEmulation :: (Eq a, Num a) => a -> MiddleEmulationState
intToMiddleEmulation 0 = MiddleEmulationDisabled
{-# LINE 237 "src/System/InputDevice.hsc" #-}
intToMiddleEmulation 1  = MiddleEmulationEnabled
{-# LINE 238 "src/System/InputDevice.hsc" #-}


data ScrollMethod
    = ScrollNoScroll
    | Scroll2fg
    | SrollEdge
    | ScrollOnButtonDown
    deriving (Eq, Show, Read)

scrollMethodToInt :: Num a => ScrollMethod -> a
scrollMethodToInt ScrollNoScroll     = 0
{-# LINE 249 "src/System/InputDevice.hsc" #-}
scrollMethodToInt Scroll2fg          = 1
{-# LINE 250 "src/System/InputDevice.hsc" #-}
scrollMethodToInt SrollEdge          = 2
{-# LINE 251 "src/System/InputDevice.hsc" #-}
scrollMethodToInt ScrollOnButtonDown = 4
{-# LINE 252 "src/System/InputDevice.hsc" #-}

intToScrollMethod :: (Eq a, Num a) => a -> ScrollMethod
intToScrollMethod 0      = ScrollNoScroll
{-# LINE 255 "src/System/InputDevice.hsc" #-}
intToScrollMethod 1            = Scroll2fg
{-# LINE 256 "src/System/InputDevice.hsc" #-}
intToScrollMethod 2           = SrollEdge
{-# LINE 257 "src/System/InputDevice.hsc" #-}
intToScrollMethod 4 = ScrollOnButtonDown
{-# LINE 258 "src/System/InputDevice.hsc" #-}


data SendEventsMode
    = SendEventsEnabled
    | SendEventsDisabled
    | SendEventsDisabledOnExternalMouse
    deriving (Eq, Show, Read)

sendEventsModeToInt :: Num a => SendEventsMode -> a
sendEventsModeToInt SendEventsEnabled                 = 0
{-# LINE 268 "src/System/InputDevice.hsc" #-}
sendEventsModeToInt SendEventsDisabled                = 1
{-# LINE 269 "src/System/InputDevice.hsc" #-}
sendEventsModeToInt SendEventsDisabledOnExternalMouse = 2
{-# LINE 270 "src/System/InputDevice.hsc" #-}

intToSendEventsMode :: (Eq a, Num a) => a -> SendEventsMode
intToSendEventsMode 0                    = SendEventsEnabled
{-# LINE 273 "src/System/InputDevice.hsc" #-}
intToSendEventsMode 1                   = SendEventsDisabled
{-# LINE 274 "src/System/InputDevice.hsc" #-}
intToSendEventsMode 2 = SendEventsDisabledOnExternalMouse
{-# LINE 275 "src/System/InputDevice.hsc" #-}


data ConfigStatus
    = StatusSuccess
    | StatusUnsupported
    | StatusInvalid
    deriving (Eq, Show, Read)

configStatusToInt :: Num a => ConfigStatus -> a
configStatusToInt StatusSuccess     = 0
{-# LINE 285 "src/System/InputDevice.hsc" #-}
configStatusToInt StatusUnsupported = 1
{-# LINE 286 "src/System/InputDevice.hsc" #-}
configStatusToInt StatusInvalid     = 2
{-# LINE 287 "src/System/InputDevice.hsc" #-}

intToConfigStatus :: (Eq a, Num a) => a -> ConfigStatus
intToConfigStatus 0     = StatusSuccess
{-# LINE 290 "src/System/InputDevice.hsc" #-}
intToConfigStatus 1 = StatusUnsupported
{-# LINE 291 "src/System/InputDevice.hsc" #-}
intToConfigStatus 2     = StatusInvalid
{-# LINE 292 "src/System/InputDevice.hsc" #-}


data TapButtonMap
    = TapMapLRM
    | TapMapLMR
    deriving (Eq, Show, Read)

tapButtonMapToInt :: Num a => TapButtonMap -> a
tapButtonMapToInt TapMapLRM = 0
{-# LINE 301 "src/System/InputDevice.hsc" #-}
tapButtonMapToInt TapMapLMR = 1
{-# LINE 302 "src/System/InputDevice.hsc" #-}

intToTapButtonMap :: (Eq a, Num a) => a -> TapButtonMap
intToTapButtonMap 0 = TapMapLRM
{-# LINE 305 "src/System/InputDevice.hsc" #-}
intToTapButtonMap 1 = TapMapLMR
{-# LINE 306 "src/System/InputDevice.hsc" #-}


data TapState
    = TapDisabled
    | TapEnabled
    deriving (Eq, Show, Read)

tapStateToInt :: Num a => TapState -> a
tapStateToInt TapDisabled = 0
{-# LINE 315 "src/System/InputDevice.hsc" #-}
tapStateToInt TapEnabled  = 1
{-# LINE 316 "src/System/InputDevice.hsc" #-}

intToTapState :: (Eq a, Num a) => a -> TapState
intToTapState 0 = TapDisabled
{-# LINE 319 "src/System/InputDevice.hsc" #-}
intToTapState 1  = TapEnabled
{-# LINE 320 "src/System/InputDevice.hsc" #-}






foreign import ccall unsafe "libinput_config_status_to_str" c_status_to_str :: CInt -> IO CString

statusToText :: ConfigStatus -> IO (Maybe Text)
statusToText status = do
    ret <- c_status_to_str $ configStatusToInt status
    if ret == nullPtr
        then pure Nothing
        else Just . E.decodeUtf8 <$> unsafePackCString ret

foreign import ccall unsafe "libinput_device_config_accel_get_default_profile" c_accel_get_default_profile :: Ptr InputDevice -> IO CInt

getDefaultAccelProfile :: InputDevice -> IO AccelProfile
getDefaultAccelProfile = fmap intToAccelProfile . c_accel_get_default_profile . unID

foreign import ccall unsafe "libinput_device_config_accel_get_default_speed" c_accel_get_default_speed :: Ptr InputDevice -> IO Double

getDefaultAccelSpeed :: InputDevice -> IO Double
getDefaultAccelSpeed = c_accel_get_default_speed . unID

foreign import ccall unsafe "libinput_device_config_accel_get_profile" c_accel_get_profile :: Ptr InputDevice -> IO CInt

getAccelProfile :: InputDevice -> IO AccelProfile
getAccelProfile = fmap intToAccelProfile . c_accel_get_profile . unID

foreign import ccall unsafe "libinput_device_config_accel_get_profiles" c_accel_get_profiles :: Ptr InputDevice -> IO Word32

getAccelProfiles :: InputDevice -> IO [AccelProfile]
getAccelProfiles (InputDevice ptr) = do
    profiles <- c_accel_get_profiles ptr
    let none     = if accelProfileToInt AccelProfileNone .&. profiles /= 0 then (AccelProfileNone:) else id
        flat     = if accelProfileToInt AccelProfileFlat .&. profiles /= 0 then (AccelProfileFlat:) else id
        adaptive = if accelProfileToInt AccelProfileAdaptive .&. profiles /= 0 then (AccelProfileAdaptive:) else id
     in pure . none . flat . adaptive $ []

foreign import ccall unsafe "libinput_device_config_accel_get_speed" c_accel_get_speed :: Ptr InputDevice -> IO Double

getAccelSpeed :: InputDevice -> IO Double
getAccelSpeed = c_accel_get_speed . unID

foreign import ccall unsafe "libinput_device_config_accel_is_available" c_accel_is_available :: Ptr InputDevice -> IO CInt

isAccelAvailable :: InputDevice -> IO Bool
isAccelAvailable = fmap (/= 0) . c_accel_is_available . unID

foreign import ccall unsafe "libinput_device_config_accel_set_profile" c_accel_set_profile :: Ptr InputDevice -> CInt -> IO CInt

setAccelProfile :: InputDevice -> AccelProfile -> IO ConfigStatus
setAccelProfile (InputDevice ptr) profile = intToConfigStatus <$> c_accel_set_profile ptr (accelProfileToInt profile)

foreign import ccall unsafe "libinput_device_config_accel_set_speed" c_accel_set_speed :: Ptr InputDevice -> Double -> IO CInt

setAccelSpeed :: InputDevice -> Double -> IO ConfigStatus
setAccelSpeed (InputDevice ptr) speed = intToConfigStatus <$> c_accel_set_speed ptr speed





foreign import ccall unsafe "libinput_device_config_calibration_get_default_matrix" c_calibration_get_default_matrix :: Ptr InputDevice -> Ptr Float -> IO CInt

getCalibrationDefaultMatrix :: InputDevice -> IO (Maybe [Float])
getCalibrationDefaultMatrix (InputDevice ptr) = allocaBytes (sizeOf (undefined :: Float) * 9) $ \matrix -> do
    ret <- c_calibration_get_default_matrix ptr matrix
    if ret == 0
        then pure Nothing
        else Just <$> mapM (peekElemOff matrix) [0..8]

foreign import ccall unsafe "libinput_device_config_calibration_get_matrix" c_calibration_get_matrix :: Ptr InputDevice -> Ptr Float -> IO CInt

getCalibrationMatrix :: InputDevice -> IO (Maybe [Float])
getCalibrationMatrix (InputDevice ptr) = allocaBytes (sizeOf (undefined :: Float) * 9) $ \matrix -> do
    ret <- c_calibration_get_matrix ptr matrix
    if ret == 0
        then pure Nothing
        else Just <$> mapM (peekElemOff matrix) [0..8]

foreign import ccall unsafe "libinput_device_config_calibration_has_matrix" c_calibration_has_matrix :: Ptr InputDevice -> IO CInt

hasCalibrationMatrix :: InputDevice -> IO Bool
hasCalibrationMatrix = fmap (/= 0) . c_calibration_has_matrix . unID

foreign import ccall unsafe "libinput_device_config_calibration_set_matrix" c_calibration_set_matrix :: Ptr InputDevice -> Ptr Float -> IO CInt

setCalibrationMatrix :: InputDevice -> [Float] -> IO ConfigStatus
setCalibrationMatrix (InputDevice ptr) mat = allocaBytes (sizeOf (undefined :: Float) * 9) $ \matrix -> do
    mapM_ (uncurry $ pokeElemOff matrix) $ zip [0..] mat
    intToConfigStatus <$> c_calibration_set_matrix ptr matrix





foreign import ccall unsafe "libinput_device_config_click_get_default_method" c_click_get_default_method :: Ptr InputDevice -> IO CInt

getClickDefaultMethod :: InputDevice -> IO ClickMethod
getClickDefaultMethod = fmap intToClickMethod . c_click_get_default_method . unID

foreign import ccall unsafe "libinput_device_config_click_get_method" c_click_get_method :: Ptr InputDevice -> IO CInt

getClickMethod :: InputDevice -> IO ClickMethod
getClickMethod = fmap intToClickMethod . c_click_get_method . unID

foreign import ccall unsafe "libinput_device_config_click_get_methods" c_click_get_methods :: Ptr InputDevice -> IO Word32

getClickMethods :: InputDevice -> IO [ClickMethod]
getClickMethods (InputDevice ptr) = do
    profiles <- c_click_get_methods ptr
    let none     = if clickMethodToInt ClickMethodNone        .&. profiles /= 0 then (ClickMethodNone       :) else id
        flat     = if clickMethodToInt ClickMethodButtonAreas .&. profiles /= 0 then (ClickMethodButtonAreas:) else id
        adaptive = if clickMethodToInt ClickMethodClickFinger .&. profiles /= 0 then (ClickMethodClickFinger:) else id
     in pure . none . flat . adaptive $ []

foreign import ccall unsafe "libinput_device_config_click_set_method" c_click_set_method :: Ptr InputDevice -> CInt -> IO CInt

setClickMethod :: InputDevice -> ClickMethod -> IO ConfigStatus
setClickMethod (InputDevice ptr) method = intToConfigStatus <$> c_click_set_method ptr (clickMethodToInt method)




foreign import ccall unsafe "libinput_device_config_dwt_get_default_enabled" c_dwt_get_default_enabled :: Ptr InputDevice -> IO CInt

getDWTDefaultEnabled :: InputDevice -> IO DWTState
getDWTDefaultEnabled = fmap intToDWTState . c_dwt_get_default_enabled . unID

foreign import ccall unsafe "libinput_device_config_dwt_get_enabled" c_dwt_get_enabled :: Ptr InputDevice -> IO CInt

getDWTEnabled :: InputDevice -> IO DWTState
getDWTEnabled = fmap intToDWTState . c_dwt_get_enabled . unID

foreign import ccall unsafe "libinput_device_config_dwt_is_available" c_dwt_is_available :: Ptr InputDevice -> IO CInt

isDWTAvailable :: InputDevice -> IO Bool
isDWTAvailable = fmap (/= 0) . c_dwt_is_available . unID

foreign import ccall unsafe "libinput_device_config_dwt_set_enabled" c_dwt_set_enabled :: Ptr InputDevice -> CInt -> IO CInt

setDWTEnabled :: InputDevice -> DWTState -> IO ConfigStatus
setDWTEnabled (InputDevice ptr) state = intToConfigStatus <$> c_dwt_set_enabled ptr (dwtStateToInt state)




foreign import ccall unsafe "libinput_device_config_left_handed_get" c_left_handed_get :: Ptr InputDevice -> IO CInt

getLeftHanded :: InputDevice -> IO Bool
getLeftHanded = fmap (/= 0) . c_left_handed_get . unID

foreign import ccall unsafe "libinput_device_config_left_handed_get_default" c_left_handed_get_default :: Ptr InputDevice -> IO CInt

getDefaultLeftHanded :: InputDevice -> IO Bool
getDefaultLeftHanded = fmap (/= 0) . c_left_handed_get_default . unID

foreign import ccall unsafe "libinput_device_config_left_handed_is_available" c_left_handed_is_available :: Ptr InputDevice -> IO CInt

isLeftHandledAvailable :: InputDevice -> IO Bool
isLeftHandledAvailable = fmap (/= 0) . c_left_handed_is_available . unID

foreign import ccall unsafe "libinput_device_config_left_handed_set" c_left_handed_set :: Ptr InputDevice -> CInt -> IO CInt

setLeftHanded :: InputDevice -> Bool -> IO ConfigStatus
setLeftHanded (InputDevice ptr) state = intToConfigStatus <$> c_left_handed_set ptr (if state then 1 else 0)




foreign import ccall unsafe "libinput_device_config_middle_emulation_get_default_enabled" c_middle_emulation_get_default_enabled :: Ptr InputDevice -> IO CInt

getMiddleEmulationDefaultEnabled :: InputDevice -> IO MiddleEmulationState
getMiddleEmulationDefaultEnabled = fmap intToMiddleEmulation . c_middle_emulation_get_default_enabled . unID

foreign import ccall unsafe "libinput_device_config_middle_emulation_get_enabled" c_middle_emulation_get_enabled :: Ptr InputDevice -> IO CInt

getMiddleEmulationEnabled :: InputDevice -> IO MiddleEmulationState
getMiddleEmulationEnabled = fmap intToMiddleEmulation . c_middle_emulation_get_enabled . unID

foreign import ccall unsafe "libinput_device_config_middle_emulation_is_available" c_middle_emulation_is_available :: Ptr InputDevice -> IO CInt

isMiddleEmulationAvailable :: InputDevice -> IO Bool
isMiddleEmulationAvailable = fmap (/= 0) . c_middle_emulation_is_available . unID

foreign import ccall unsafe "libinput_device_config_middle_emulation_set_enabled" c_middle_emulation_set_enabled :: Ptr InputDevice -> CInt -> IO CInt

setMiddleEmulationEnabled :: InputDevice -> MiddleEmulationState -> IO ConfigStatus
setMiddleEmulationEnabled (InputDevice ptr) state = intToConfigStatus <$> c_left_handed_set ptr (middleEmulationToInt state)





foreign import ccall unsafe "libinput_device_config_rotation_get_angle" c_rotation_get_angle :: Ptr InputDevice -> IO CUInt

getRotationAngle :: InputDevice -> IO Word
getRotationAngle = fmap fromIntegral . c_rotation_get_angle . unID

foreign import ccall unsafe "libinput_device_config_rotation_get_default_angle" c_rotation_get_default_angle :: Ptr InputDevice -> IO CUInt

getRotationDefaultAngle :: InputDevice -> IO Word
getRotationDefaultAngle = fmap fromIntegral . c_rotation_get_default_angle . unID

foreign import ccall unsafe "libinput_device_config_rotation_is_available" c_rotation_is_available :: Ptr InputDevice -> IO CInt

isRotationAvailable :: InputDevice -> IO Bool
isRotationAvailable = fmap (/= 0) . c_rotation_is_available . unID

foreign import ccall unsafe "libinput_device_config_rotation_set_angle" c_rotation_set_angle :: Ptr InputDevice -> CUInt -> IO CInt

setRotationDefaultAngle :: InputDevice -> Word -> IO ConfigStatus
setRotationDefaultAngle (InputDevice ptr) angle = intToConfigStatus <$> c_rotation_set_angle ptr (fromIntegral angle)





foreign import ccall unsafe "libinput_device_config_scroll_get_button" c_scroll_get_button :: Ptr InputDevice -> IO Word32

getScrollButton :: InputDevice -> IO Word32
getScrollButton = c_scroll_get_button . unID

foreign import ccall unsafe "libinput_device_config_scroll_get_default_button" c_scroll_get_default_button :: Ptr InputDevice -> IO Word32

getScrollDefaultButton :: InputDevice -> IO Word32
getScrollDefaultButton = c_scroll_get_default_button . unID

foreign import ccall unsafe "libinput_device_config_scroll_get_default_method" c_scroll_get_default_method :: Ptr InputDevice -> IO CInt

getScrollDefaultMethod :: InputDevice -> IO ScrollMethod
getScrollDefaultMethod = fmap intToScrollMethod . c_scroll_get_default_method . unID

foreign import ccall unsafe "libinput_device_config_scroll_get_method" c_scroll_get_method :: Ptr InputDevice -> IO CInt

getScrollMethod :: InputDevice -> IO ScrollMethod
getScrollMethod = fmap intToScrollMethod . c_scroll_get_method . unID

foreign import ccall unsafe "libinput_device_config_scroll_get_methods" c_scroll_get_methods :: Ptr InputDevice -> IO Word32

getScrollMethods :: InputDevice -> IO [ScrollMethod]
getScrollMethods (InputDevice ptr) = do
    methods <- c_scroll_get_methods ptr
    let none     = if scrollMethodToInt ScrollNoScroll     .&. methods /= 0 then (ScrollNoScroll    :) else id
        flat     = if scrollMethodToInt Scroll2fg          .&. methods /= 0 then (Scroll2fg         :) else id
        adaptive = if scrollMethodToInt SrollEdge          .&. methods /= 0 then (SrollEdge         :) else id
        onbdown  = if scrollMethodToInt ScrollOnButtonDown .&. methods /= 0 then (ScrollOnButtonDown:) else id

     in pure . none . flat . adaptive . onbdown $ []

foreign import ccall unsafe "libinput_device_config_scroll_set_button" c_scroll_set_button :: Ptr InputDevice -> Word32 -> IO CInt

setScrollButton :: InputDevice -> Word32 -> IO ConfigStatus
setScrollButton (InputDevice ptr) button = intToConfigStatus <$> c_scroll_set_button ptr button

foreign import ccall unsafe "libinput_device_config_scroll_set_method" c_scroll_set_method :: Ptr InputDevice -> CInt -> IO CInt

setScrollMethod :: InputDevice -> ScrollMethod -> IO ConfigStatus
setScrollMethod (InputDevice ptr) method = intToConfigStatus <$> c_scroll_set_method ptr (scrollMethodToInt method)





foreign import ccall unsafe "libinput_device_config_scroll_get_default_natural_scroll_enabled" c_scroll_get_default_natural_scroll_enabled :: Ptr InputDevice -> IO CInt

getNaturalScrollDefaultEnabled :: InputDevice -> IO Bool
getNaturalScrollDefaultEnabled = fmap (/= 0) . c_scroll_get_default_natural_scroll_enabled . unID

foreign import ccall unsafe "libinput_device_config_scroll_get_natural_scroll_enabled" c_scroll_get_natural_scroll_enabled :: Ptr InputDevice -> IO CInt

getNaturalScrollEnabled :: InputDevice -> IO Bool
getNaturalScrollEnabled = fmap (/= 0) . c_scroll_get_natural_scroll_enabled . unID

foreign import ccall unsafe "libinput_device_config_scroll_has_natural_scroll" c_scroll_has_natural_scroll :: Ptr InputDevice -> IO CInt

hasNaturalScroll :: InputDevice -> IO Bool
hasNaturalScroll = fmap (/= 0) . c_scroll_has_natural_scroll . unID

foreign import ccall unsafe "libinput_device_config_scroll_set_natural_scroll_enabled" c_scroll_set_natural_scroll_enabled :: Ptr InputDevice -> CInt -> IO CInt

setNaturalScrollenabled :: InputDevice -> Bool -> IO ConfigStatus
setNaturalScrollenabled (InputDevice ptr) method = intToConfigStatus <$> c_scroll_set_natural_scroll_enabled ptr (if method then 1 else 0)




readSendEventsModes :: Word32 -> [SendEventsMode]
readSendEventsModes modes = 
    let none     = if sendEventsModeToInt SendEventsEnabled                 .&. modes /= 0 then (SendEventsEnabled                :) else id
        flat     = if sendEventsModeToInt SendEventsDisabled                .&. modes /= 0 then (SendEventsDisabled               :) else id
        adaptive = if sendEventsModeToInt SendEventsDisabledOnExternalMouse .&. modes /= 0 then (SendEventsDisabledOnExternalMouse:) else id

     in none . flat . adaptive $ []

foreign import ccall unsafe "libinput_device_config_send_events_get_default_mode" c_send_events_get_default_mode :: Ptr InputDevice -> IO Word32

getSendEventsDefaultMode :: InputDevice -> IO [SendEventsMode]
getSendEventsDefaultMode = fmap readSendEventsModes . c_send_events_get_default_mode . unID

foreign import ccall unsafe "libinput_device_config_send_events_get_mode" c_send_events_get_mode :: Ptr InputDevice -> IO Word32

getSendEventsMode :: InputDevice -> IO [SendEventsMode]
getSendEventsMode = fmap readSendEventsModes . c_send_events_get_mode . unID

foreign import ccall unsafe "libinput_device_config_send_events_get_modes" c_send_events_get_modes :: Ptr InputDevice -> IO Word32

getSendEventsModes :: InputDevice -> IO [SendEventsMode]
getSendEventsModes (InputDevice ptr) = readSendEventsModes <$> c_scroll_get_methods ptr

foreign import ccall unsafe "libinput_device_config_send_events_set_mode" c_send_events_set_mode :: Ptr InputDevice -> Word32 -> IO CInt

setSendEventsMode :: InputDevice -> [SendEventsMode] -> IO ConfigStatus
setSendEventsMode (InputDevice ptr) modes = intToConfigStatus <$> c_send_events_set_mode ptr (foldr (.|.) 0 $ map sendEventsModeToInt modes)






foreign import ccall unsafe "libinput_device_config_tap_get_button_map" c_tap_get_button_map :: Ptr InputDevice -> IO CInt

getTapButtonMap :: InputDevice -> IO TapButtonMap
getTapButtonMap = fmap intToTapButtonMap . c_tap_get_button_map . unID

foreign import ccall unsafe "libinput_device_config_tap_get_default_button_map" c_tap_get_default_button_map :: Ptr InputDevice -> IO CInt

getTapDefaultButtonMap :: InputDevice -> IO TapButtonMap
getTapDefaultButtonMap = fmap intToTapButtonMap . c_tap_get_default_button_map . unID

foreign import ccall unsafe "libinput_device_config_tap_set_button_map" c_tap_set_button_map :: Ptr InputDevice -> CInt -> IO CInt

setTapButtonMap :: InputDevice -> TapButtonMap -> IO ConfigStatus
setTapButtonMap (InputDevice ptr) bmap = intToConfigStatus <$> c_send_events_set_mode ptr (tapButtonMapToInt bmap)




foreign import ccall unsafe "libinput_device_config_tap_get_default_drag_enabled" c_tap_get_default_drag_enabled :: Ptr InputDevice -> IO CInt

getTapDefaultDragEnabled :: InputDevice -> IO DragState
getTapDefaultDragEnabled = fmap intToDragState . c_tap_get_default_drag_enabled . unID

foreign import ccall unsafe "libinput_device_config_tap_get_drag_enabled" c_tap_get_drag_enabled :: Ptr InputDevice -> IO CInt

getTapDragEnabled :: InputDevice -> IO DragState
getTapDragEnabled = fmap intToDragState . c_tap_get_drag_enabled . unID

foreign import ccall unsafe "libinput_device_config_tap_set_drag_enabled" c_tap_set_drag_enabled :: Ptr InputDevice -> CInt -> IO CInt

setTapDragEnabled :: InputDevice -> DragState -> IO ConfigStatus
setTapDragEnabled (InputDevice ptr) state = intToConfigStatus <$> c_tap_set_drag_enabled ptr (dragStateToInt state)



foreign import ccall unsafe "libinput_device_config_tap_get_default_drag_lock_enabled" c_tap_get_default_drag_lock_enabled :: Ptr InputDevice -> IO CInt

getTapDefaultDragLockEnabled :: InputDevice -> IO DragLockState
getTapDefaultDragLockEnabled = fmap intToDragLockState . c_tap_get_default_drag_lock_enabled . unID

foreign import ccall unsafe "libinput_device_config_tap_get_drag_lock_enabled" c_tap_get_drag_lock_enabled :: Ptr InputDevice -> IO CInt

getTapDragLockEnabled :: InputDevice -> IO DragLockState
getTapDragLockEnabled = fmap intToDragLockState . c_tap_get_drag_lock_enabled . unID

foreign import ccall unsafe "libinput_device_config_tap_set_drag_lock_enabled" c_tap_set_drag_lock_enabled :: Ptr InputDevice -> CInt -> IO CInt

setTapDragLockEnabled :: InputDevice -> DragLockState -> IO ConfigStatus
setTapDragLockEnabled (InputDevice ptr) state = intToConfigStatus <$> c_tap_set_drag_lock_enabled ptr (dragLockStateToInt state)




foreign import ccall unsafe "libinput_device_config_tap_get_enabled" c_tap_get_enabled :: Ptr InputDevice -> IO CInt

getTapEnabled :: InputDevice -> IO TapState
getTapEnabled = fmap intToTapState . c_tap_get_enabled . unID

foreign import ccall unsafe "libinput_device_config_tap_get_default_enabled" c_tap_get_default_enabled :: Ptr InputDevice -> IO CInt

getTapDefaultEnabled :: InputDevice -> IO TapState
getTapDefaultEnabled = fmap intToTapState . c_tap_get_default_enabled . unID

foreign import ccall unsafe "libinput_device_config_tap_set_enabled" c_tap_set_enabled :: Ptr InputDevice -> CInt -> IO CInt

setTapEnabled :: InputDevice -> TapState -> IO ConfigStatus
setTapEnabled (InputDevice ptr) state = intToConfigStatus <$> c_tap_set_enabled ptr (tapStateToInt state)

foreign import ccall unsafe "libinput_device_config_tap_get_finger_count" c_get_finger_count :: Ptr InputDevice -> IO CInt

getTapFingerCount :: InputDevice -> IO Int
getTapFingerCount = fmap fromIntegral . c_get_finger_count . unID
