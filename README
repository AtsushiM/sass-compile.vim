# sass-compile.vim
sass、compassの自動コンパイルを提供するプラグインです。
scssファイルの保存時などに自動的にコンパイルコマンドを実行します。
compass watchなどと違い、保存毎にコマンドを発行するため、
プロセスが残らず、複数の案件の切替が激しい方などにおすすめです。

## install
```
NeoBundle 'AtsushiM/search-parent.vim'
NeoBundle 'AtsushiM/sass-compile.vim'
```

### :SassCompile
Sassのコンパイルを行います。
現在編集中のファイルから逆上って、config.rb(compass用設定ファイル)か
特定のフォルダ名(cssのフォルダ)を発見した場合、コンパイルを実行します。

### :CompassConfig
compassの設定ファイル(config.rb)をeditコマンドで開きます。

## 設定例
```
" 編集したファイルから遡るフォルダの最大数
let g:sass_compile_cdloop = 5

" ファイル保存時に自動コンパイル（1で自動実行）
let g:sass_compile_auto = 0

" 自動コンパイルを実行する拡張子
let g:sass_compile_file = ['scss', 'sass']

" cssファイルが入っているディレクトリ名（前のディレクトリほど優先）
let g:sass_compile_cssdir = ['css', 'stylesheet']

" コンパイル実行前に実行したいコマンドを設定
" 例：growlnotifyによる通知
" let g:sass_compile_beforecmd = "growlnotify -t 'sass-compile.vim' -m 'start sass compile.'"

" コンパイル実行後に実行したいコマンドを設定
" 例：growlnotifyによる通知(${sasscompileresult}は実行結果)
" let g:sass_compile_aftercmd = "growlnotify -t 'sass-compile.vim' -m ${sasscompileresult}"
```

## 注意
vimの$PATHでcompassへのパスが通ってない場合、コンパイルされない場合があります。
その場合はvimrcなどで$PATHの設定が必要です。
```
let $PATH=$PATH."path_to_compass"
```
