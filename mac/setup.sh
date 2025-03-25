#!/bin/bash

set -eu pipefail

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"

# shellcheck source=/dev/null
if [ -n "$BASH_VERSION" ]; then
  SOURCE_CMD="source"
elif [ -n "$ZSH_VERSION" ]; then
  SOURCE_CMD="source"
else
  SOURCE_CMD="."
fi

$SOURCE_CMD "${THIS_DIR}/../utils.sh"

check_requirements() {
  if [ "$(uname)" != "Darwin" ]; then
    log "Error: This script is for macOS only!"
    return 1
  fi
}

if [ "$(uname)" != "Darwin" ]; then
  log "This script is for macOS only!"
  exit 1
fi

configure_sound_effects() {
  log "Configuring sound effects..."

  sudo nvram StartupMute=%01 #起動音をミュート

  log "Complete configuring sound effects!"
}

configure_scrollbar() {
  log "Configuring scrollbar..."

  defaults write NSGlobalDomain AppleShowScrollBars -string "Always" # スクロールバーを常に表示

  log "Complete configuring scrollbar!"
}

configure_time() {
  log "Configuring time settings..."

  defaults write NSGlobalDomain AppleICUForce24HourTime -bool true                           # 24時間表示にする
  defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm:ss" # メニューバーの時計フォーマットを「月日(曜日) 時:分:秒」に設定

  log "Complete configuring time settings!"
}

configure_battery() {
  log "Configuring battery settings..."

  sudo pmset -a LowPowerMode 0 # Low Power Modeを無効化

  log "Complete configuring battery settings!"
}

configure_screenshot() {
  log "Configuring screenshot settings..."

  defaults write com.apple.screencapture "disable-shadow" -bool true # スクリーンショットに影を付けない
  defaults write com.apple.screencapture location ~/Downloads        # スクリーンショットの保存先をDownloadsに変更
  defaults write com.apple.screencapture type -string "png"          # スクリーンショットのファイル形式をPNGに変更

  log "Complete configuring screenshot settings!"
}

configure_controlcenter() {
  log "Configuring control center settings..."

  defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool false                   # Wi-Fi: メニューバーに表示しない
  defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool false              # Bluetooth: メニューバーに表示しない
  defaults write com.apple.controlcenter "NSStatusItem Visible AirDrop" -bool false                # AirDrop: メニューバーに表示しない
  defaults write com.apple.controlcenter "NSStatusItem Visible FocusModes" -bool false             # Focus: メニューバーに表示しない
  defaults write com.apple.controlcenter "NSStatusItem Visible StageManager" -bool false           # Stage Manager: メニューバーに表示しない
  defaults write com.apple.controlcenter "NSStatusItem Visible ScreenMirroring" -bool true         # Screen Mirroring: 使用時のみメニューバーに表示
  defaults write com.apple.controlcenter "NSStatusItem Visible Display" -bool true                 # Display: 使用時のみメニューバーに表示
  defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true                   # Sound: 常にメニューバーに表示
  defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" -bool true              # Now Playing: 使用時のみメニューバーに表示
  defaults write com.apple.controlcenter "NSStatusItem Visible AccessibilityShortcuts" -bool false # Accessibility Shortcuts: メニューバーには表示しないが、コントロールセンターには表示
  defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool true                 # Battery: メニューバーとコントロールセンターに表示
  defaults write com.apple.controlcenter "BatteryShowPercentage" -bool true                        # Battery: メニューバーとコントロールセンターに表示
  defaults write com.apple.Spotlight "NSStatusItem Visible Item" -bool false                       # Spotlight: メニューバーに表示しない
  defaults write com.apple.Siri "StatusMenuVisible" -bool true                                     # Siri: メニューバーに表示する
  defaults write com.apple.controlcenter "NSStatusItem Visible TimeMachine" -bool false            # Time Machine: メニューバーに表示しない
  defaults write com.apple.controlcenter "NSStatusItem Visible VPN" -bool false                    # VPN: メニューバーに表示しない
  defaults write com.apple.controlcenter "NSStatusItem Visible Weather" -bool false                # Weather: メニューバーに表示しない

  killall ControlCenter

  log "Complete configuring control center settings!"
}

configure_dock_desktop() {
  log "Configuring Dock and Desktop settings..."

  # Dock
  defaults write com.apple.dock tilesize -int 48                            # アイコンサイズを48pxに
  defaults write com.apple.dock magnification -bool false                   # Dock の拡大を無効化
  defaults write com.apple.dock orientation -string "right"                 # 位置を右
  defaults write com.apple.dock mineffect -string "genie"                   # 最小化エフェクトをジニーに
  defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Maximize" # タイトルバーのダブルクリックをズームに
  defaults write com.apple.dock minimize-to-application -bool true          # ウィンドウをアプリアイコンに最小化する
  defaults write com.apple.dock autohide -bool true                         # Dock を自動的に隠す
  defaults write com.apple.dock launchanim -bool false                      # アプリ起動時のアニメーションをオフ
  defaults write com.apple.dock show-process-indicators -bool true          # 開いているアプリのインジケーターを表示
  defaults write com.apple.dock show-recents -bool false                    # 最近使ったアプリを Dock に表示しない

  # Desktop & Stage Manager 設定
  defaults write com.apple.finder CreateDesktop -bool true                               # デスクトップアイテムを表示
  defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool true     # デスクトップを表示するために壁紙をクリック
  defaults write com.apple.WindowManager StageManager -bool false                        # Stage Manager を無効化
  defaults write com.apple.WindowManager ShowRecentApplications -bool true               # 最近使ったアプリを Stage Manager に表示
  defaults write com.apple.WindowManager GroupWindowsByApplication -string "all-at-once" # アプリのウィンドウ表示を「すべて同時」

  # ウィジェット設定
  defaults write com.apple.desktoppicture ShowWidgets -bool true  # デスクトップにウィジェットを表示
  defaults write com.apple.StageManager ShowWidgets -bool true    # Stage Manager でウィジェットを表示
  defaults write com.apple.widget.WidgetStyle -string "automatic" # ウィジェットスタイルを自動
  defaults write com.apple.widget.UseiPhoneWidgets -bool true     # iPhone ウィジェットを有効化

  # Windows 設定
  defaults write NSGlobalDomain AppleWindowTabbingMode -string "fullscreen" # タブ優先（フルスクリーン時のみ）
  defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool false    # ドキュメント変更時の確認をオフ
  defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false        # アプリ終了時にウィンドウを閉じる

  # タイル化関連の設定（すべてオフ）
  defaults write com.apple.WindowManager EnableTiling -bool false
  defaults write com.apple.WindowManager EnableFullscreenOnDrag -bool false
  defaults write com.apple.WindowManager EnableSnapToEdge -bool false
  defaults write com.apple.WindowManager TiledWindowsHaveMargins -bool false

  # Mission Control 設定
  defaults write com.apple.dock mru-spaces -bool false              # 最近使用した順に Space を自動配置しない
  defaults write com.apple.dock appswitcher-all-displays -bool true # アプリ切り替え時に開いている Space に移動
  defaults write com.apple.dock expose-group-by-app -bool false     # アプリごとにウィンドウをグループ化しない
  defaults write com.apple.spaces spans-displays -bool true         # ディスプレイごとに Space を分離
  defaults write com.apple.dock hot-corners -bool true              # 画面上部へのドラッグで Mission Control に入る

  # 設定を適用
  killall Dock
  killall Finder

  log "Complete configuring Dock and Desktop settings!"
}

configure_notifications() {
  log "Configuring Notification Center settings..."

  defaults write com.apple.notificationcenterui bannerPreviewStyle -int 2               # 通知のプレビューを「ロック解除時のみ」に設定
  defaults write com.apple.notificationcenterui doNotDisturb -bool true                 # ディスプレイがスリープ中でも通知を許可しない
  defaults write com.apple.notificationcenterui screenSharingDoNotDisturb -bool true    # 画面ミラーリングまたは共有時の通知を許可しない
  defaults write com.apple.notificationcenterui iPhoneNotificationForwarding -bool true # iPhone からの通知を許可

  killall NotificationCenter

  log "Complete configuring Notification Center settings!"
}

configure_sound() {
  log "Configuring Sound settings..."

  sudo nvram SystemAudioVolume="%00"                                                                           # 起動時のサウンドをオフ
  defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -bool true                                     # UI のサウンドエフェクトを有効化
  defaults write -g com.apple.sound.beep.feedback -bool false                                                  # 音量変更時のフィードバック音を無効化
  defaults write com.apple.systemsound "com.apple.sound.beep.sound" -string "/System/Library/Sounds/Boop.aiff" # 警告音を "Boop" に設定

  log "Complete configuring Sound settings!"
}

configure_focus() {
  log "Configuring Focus settings..."

  defaults write com.apple.ncprefs.plist focusMode -dict-add "shareAcrossDevices" -bool true # フォーカスモードをデバイス間で共有する
  defaults write com.apple.ncprefs.plist focusMode -dict-add "focusStatus" -bool true        # フォーカスステータスをアプリと共有する

  killall NotificationCenter

  log "Complete configuring Focus settings!"
}

configure_lock_screen() {
  log "Configuring Lock Screen settings..."

  defaults -currentHost write com.apple.screensaver idleTime -int 180 # スクリーンセーバーの開始時間（3 分）
  sudo pmset -b displaysleep 5                                        # バッテリー使用時のディスプレイオフ時間（5 分）
  sudo pmset -c displaysleep 5                                        # 電源接続時のディスプレイオフ時間（5 分）
  defaults write com.apple.screensaver askForPassword -int 1          # スクリーンセーバーやディスプレイオフ後のパスワード要求を即時に設定
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  # ロック画面の表示オプション
  defaults write com.apple.menuextra.clock IsAnalog -bool false                           # デジタル時計を表示
  sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false # ゲストユーザーを無効化

  log "Complete configuring Lock Screen settings!"
}

configure_security() {
  log "Configuring Security settings..."

  # 許可するアプリのソースを「App Store & Known Developers」に設定
  sudo spctl --master-enable
  sudo defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool true
  sudo defaults write /Library/Preferences/com.apple.security GKAllowAppDownloadFrom -string "identified-developers"

  sudo defaults write /Library/Preferences/com.apple.AccessorySecurity "AccessorySecurityPolicy" -int 1 # アクセサリの接続を「新しいアクセサリの接続を確認」に設定
  sudo defaults write /Library/Preferences/com.apple.security.lockdown "Mode" -bool false               # Lockdown Mode をオフに設定（Lockdown Mode の変更は手動が推奨される）
  if ! fdesetup status | grep -q "FileVault is On."; then                                               # FileVault を有効化
    sudo fdesetup enable
  else
    log "FileVault is already enabled. Skipping."
  fi
  defaults write com.apple.screensaver askForPassword -int 1      # スクリーンセーバーやスリープ解除時にパスワードを要求
  defaults write com.apple.screensaver askForPasswordDelay -int 0 # スクリーンセーバーやスリープ解除後のパスワード要求を即時に

  log "Complete configuring Security settings!"
}

configure_keyboard() {
  log "Configuring Keyboard settings..."

  defaults write NSGlobalDomain KeyRepeat -int 2                                                          # キーリピート速度（0 が最速、2 以上で遅くなる）
  defaults write NSGlobalDomain InitialKeyRepeat -int 15                                                  # キーリピート開始の遅延（短くする）
  defaults write com.apple.BezelServices kDim -bool true                                                  # 暗い環境でのキーボードバックライト自動調整を有効化
  defaults write com.apple.BezelServices kDimTime -int 0                                                  # 非アクティブ時にキーボードバックライトをオフにしない（Never）
  defaults write com.apple.HIToolbox AppleFnUsageType -int 0                                              # 🌐キーで入力ソースを切り替え
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3                                                # キーボードナビゲーションを有効化（Tab で UI 要素を移動）
  defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMEnabled -bool false # 音声入力を無効化
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false                          # オートピリオド（自動句読点）を無効化
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false                              # 自動大文字変換を無効化
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false                          # 自動スペルチェックを無効化

  log "Complete configuring Keyboard settings!"
}

configure_trackpad() {
  log "Configuring Trackpad settings..."

  defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3                                                   # トラッキング速度（1 ～ 3 の範囲で設定）
  defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 1                                         # クリック強度（0=軽い, 1=中, 2=強い）
  defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 1                                        # クリック強度（0=軽い, 1=中, 2=強い）
  defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0                                           # 静音クリック（Quiet Click）を有効化
  defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true                                         # 強めのクリックと触覚フィードバックを有効化
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0                               # ルックアップ & データ検出をオフ
  defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true                                      # 副ボタンのクリック（2 本指でクリック）
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true                     # 副ボタンのクリック（2 本指でクリック）
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true                                                # タップでクリックを有効化
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true                               # タップでクリックを有効化
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true                                             # ナチュラルスクロール（指の動きに合わせてスクロール）
  defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true                                           # ピンチでズーム
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -bool true                          # ピンチでズーム
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1                           # スマートズーム（2 本指でダブルタップ）
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 1          # スマートズーム（2 本指でダブルタップ）
  defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true                                          # 2 本指で回転
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -bool true                         # 2 本指で回転
  defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true                                        # ページ間スワイプ（2 本指で左右）
  defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 1                        # ページ間スワイプ（2 本指で左右）
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 1       # ページ間スワイプ（2 本指で左右）
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2                         # フルスクリーンアプリの切り替え（4 本指で左右）
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2        # フルスクリーンアプリの切り替え（4 本指で左右）
  defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 1                  # 通知センター（2 本指で右端からスワイプ）
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 1 # 通知センター（2 本指で右端からスワイプ）
  defaults write com.apple.dock showMissionControlGestureEnabled -bool true                                           # Mission Control（4 本指で上にスワイプ）
  defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2                          # Mission Control（4 本指で上にスワイプ）
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2         # Mission Control（4 本指で上にスワイプ）
  defaults write com.apple.dock showAppExposeGestureEnabled -bool false                                               # App Exposé をオフ
  defaults write com.apple.dock showLaunchpadGestureEnabled -bool true                                                # Launchpad（親指と 3 本指でピンチ）
  defaults write com.apple.dock showDesktopGestureEnabled -bool true                                                  # デスクトップ表示（親指と 3 本指で広げる）

  log "Complete configuring Trackpad settings!"
}

configure_mouse() {
  log "Configuring Mouse settings..."

  defaults write NSGlobalDomain com.apple.mouse.scaling -float 3.0                                   # トラッキング速度（1.0 - 3.0 の範囲で設定可能）
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true                            # ナチュラルスクロール（オン）
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton" # 副ボタンクリック（右クリックを有効化）
  defaults write NSGlobalDomain com.apple.mouse.doubleClickThreshold -float 0.75                     # ダブルクリックの速度（最速に近い設定）
  defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 0.75                            # スクロール速度（中程度に設定）

  log "Complete configuring Mouse settings!"
}

configure_finder() {
  log "Configuring Finder settings..."

  # 隠しファイルを表示
  defaults write com.apple.finder AppleShowAllFiles -bool true

  # すべてのファイル拡張子を表示
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # 新規書類の保存先を iCloud ではなくローカルにする
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # Finder の UI 設定
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true # Finder ウィンドウタイトルにフルパスを表示
  defaults write com.apple.finder FinderSounds -bool false           # Finder のサウンドをオフ
  defaults write com.apple.finder FinderSpawnTab -bool true          # 新しいウィンドウの代わりにタブで開く

  # ゴミ箱の設定
  defaults write com.apple.finder WarnOnEmptyTrash -bool false
  defaults write com.apple.finder FXRemoveOldTrashItems -bool false # 30 日後にゴミ箱から削除する設定を無効化

  # ダウンロードしたアプリの初回警告を無効化
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # デスクトップに表示するアイテム
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

  # Finder ウィンドウのデフォルトフォルダ（カスタムパス）
  defaults write com.apple.finder NewWindowTarget -string "PfLo"
  defaults write com.apple.finder NewWindowTargetPath -string "file:///Users/$(whoami)/"

  # 検索時のデフォルト動作（Mac 全体を検索）
  defaults write com.apple.finder FXDefaultSearchScope -string "SCev"

  # 拡張子変更時の警告を有効化
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool true
  defaults write com.apple.finder FXICloudDriveWarning -bool true

  # Sidebar の設定（完全リセット & 追加）
  defaults write com.apple.sidebarlists systemitems -dict \
    ShowRecents -bool false \
    ShowAirDrop -bool true \
    ShowApplications -bool true \
    ShowDownloads -bool true \
    ShowDesktop -bool false \
    ShowMovies -bool false \
    ShowMusic -bool false \
    ShowPictures -bool false \
    ShowiCloudDrive -bool true \
    ShowiCloudDocuments -bool true \
    ShowiCloudShared -bool true \
    ShowHardDisks -bool true \
    ShowExternalHardDrives -bool true \
    ShowRemovable -bool true \
    ShowCloudStorage -bool true \
    ShowBonjour -bool true \
    ShowConnectedServers -bool true \
    ShowRecentTags -bool true

  # Finder を再起動（変更を反映）
  sleep 1
  killall Finder

  log "Complete configuring Finder settings!"
}

main() {
  configure_sound_effects
  echo ""

  configure_scrollbar
  echo ""

  configure_time
  echo ""

  configure_battery
  echo ""

  configure_screenshot
  echo ""

  configure_controlcenter
  echo ""

  configure_dock_desktop
  echo ""

  configure_notifications
  echo ""

  configure_sound
  echo ""

  configure_focus
  echo ""

  configure_lock_screen
  echo ""

  configure_security
  echo ""

  configure_keyboard
  echo ""

  configure_trackpad
  echo ""

  configure_mouse
  echo ""

  configure_finder
  echo ""
}

main
