# SoundConductor
sound manager for ActionScript 3.

version : 0.1

** 執筆中 **

## 注意
このライブラリは開発中であり、幾つかの未実装機能が存在します。

- seek()
- allowMultiple
- allowInterrupt

また、テストケースがそこまで無いため、不安定な挙動やバグを起こす可能性があります。

## 解説
このライブラリは、AS3 におけるサウンドの再生を一まとめにコントロールするマネージャ的ライブラリです。

主に、以下の機能が実装されています。

- SoundGenerator 機能を使用した、始点・終点を指定した無限ループ機能
- サウンドのグルーピング機能
- ボリュームのフェードイン・アウト
- 「マスターボリューム」「グループボリューム」、そして「音そのもののボリューム」を使用した多段性のボリューム調整機能
- ポーズ・リジューム機能

主にゲームなどの、サウンドを常用的に扱うコンテンツに特化したライブラリとなっています。

## 使い方
### 前知識
このライブラリでサウンドを扱うには、基本的に「サウンドを登録する」必要があります。内容としては、

1. 「登録用データ」を作成する。
2. SoundConductor に「登録用データ」を登録する
3. 登録したデータを扱うための「再生用データ」を作成する。
4. SoundConductor に「再生用データ」を渡して再生する。

という手順を踏むことになります。

少々煩雑な扱いにはなってしまいますが、この手順を踏むことにより、多くの機能や設定を行うことが出来るようになっています。

### 初期化
このライブラリは、必ず初期化する必要があります。

`SoundConductor.initialize(true, SoundBufferType.BUFFER_SIZE_4096);`

第1引数は、「SoundGenerator 機能を使用するかどうか」を指定します。デフォルトは false です。第2引数は、SoundGenerator 機能を使用する際のバッファサイズを指定します。

### 無限ループ機能
このライブラリの目玉といえる機能です。主にゲームなどの「コンテンツの BGM 」で使える機能です。

#### まずは「登録用データ」を作成
`var soundObject:Sound = new Sound(...);
var bgm01Register:RegisterSoundInfo = new RegisterSoundInfo(soundObject, true);`

登録用データは RegisterSoundInfo オブジェクトを使用します。コンストラクタにサウンドオブジェクトを指定します。
第2引数は、PCM の ByteArray を作成するかを指定します。これを true にすると、Sound オブジェクトから PCM の ByteArray を作成します。無限ループは SoundGenerator 機能を使用するため、このパラメータは true にする必要があります。

#### SoundConductor に登録
`var soundId:SoundId = SoundConductor.registerSound(bgm01Register);`

先ほどの登録用データを、SoundConductor に登録します。登録すると、SoundId オブジェクトが返されます。これが、登録したサウンドに紐づいた ID となり、この ID を使用してサウンドの再生を行うことになります。

#### 「再生用データ」を作成
`var bgm01PlayInfo:SoundPlayInfo = new SoundPlayInfo(soundId);
bgm01PlayInfo.loops = SoundLoopType.INFINITE_LOOP;
bgm01PlayInfo.startTimeByMS = 500;	// 500ms の部分から開始
bgm01PlayInfo.loopStartTimeByMS = 7991;	// ループの際は、7991ms の部分からループ開始
bgm01PlayInfo.loopEndTimeByMS = 107650;	// 107650ms になったらループ開始位置まで戻る`

再生用データは、SoundPlayInfo オブジェクトを使用します。先ほど登録した際に入手した soundId を指定します。

このオブジェクトでは、再生情報をプロパティとして指定します。内容は上記コードのコメントを参考ください。

#### 再生
`var bgmController1:SoundController = SoundConductor.play(bgm01PlayInfo);`

先ほど作成した「再生用データ」を用いて、SoundConductor で再生を行います。これで「500ms から再生を開始し、107650ms に到達したら、7991ms に戻ってループ再生を行うという「イントロ付き無限ループ」が実現されます。

SoundController は、AS3 の Sound クラスにおける SoundChannel と同じ意味合いを持ちます。このコントローラクラスを用いて、一時停止やボリューム調整を行います。

#### 無限ループ使用の注意点
稀に、上記の設定を行っても無限ループがされない場合があります。その際は、ループの時間を少しだけ前後させてみてください。ループが機能する可能性があります。

この件についての原因は不明です。

### SoundGenerator 機能を使う際の注意点
- 音質が変化する場合があります。
- また、SoundGenerator の特性上、再生開始と終了にラグが生じます。
- PCM の ByteArray を使うため、メモリの使用量が相当にあります。特にサウンドが長ければ長いほど顕著になります。モバイルなどで扱う場合はこれが原因でアプリ自体が落ちる可能性もあります。ご注意ください。
- 大量に使うと、サウンド生成の処理が多量に走るため、パフォーマンスに影響する可能性があります。
