# SoundConductor
sound manager for ActionScript 3.

- Licence : MIT Licence.
- Version : 0.1

** 執筆中 **

## 注意
このライブラリは開発中であり、テストケースがそこまで無いため、不安定な挙動やバグを起こす可能性があります。

## 解説
このライブラリは、AS3 におけるサウンドの再生を一まとめにコントロールするマネージャ的ライブラリです。

主に、以下の機能が実装されています。

- SoundGenerator 機能を使用した、始点・終点を指定した無限ループ機能
- サウンドのグルーピング機能
- ボリュームのフェードイン・アウト
- 「マスターボリューム」「グループボリューム」、そして「音そのもののボリューム」を使用した多段性のボリューム調整機能
- ポーズ・リジューム機能

主にゲームなどの「サウンドを常用的に扱うコンテンツ」に特化したライブラリとなっています。

## 使い方
### 前知識
このライブラリでサウンドを扱うには、基本的に「サウンドを登録する」必要があります。内容としては、

1. 「登録用データ」を作成する。
2. `SoundConductor` に「登録用データ」を登録する
3. 登録したデータを扱うための「再生用データ」を作成する。
4. `SoundConductor` に「再生用データ」を渡して再生する。

という手順を踏むことになります。

少々煩雑な扱いにはなってしまいますが、この手順を踏むことにより、多くの機能や設定を行うことが出来るようになっています。

後述しますが、登録を行わずに再生することも可能です。ただし登録しない場合は、`SoundConductor` で管理されることによる様々な恩恵は受けることができません。

### 初期化
このライブラリは、必ず初期化する必要があります。

```
SoundConductor.initialize(true, SoundBufferType.BUFFER_SIZE_4096);
```

第1引数は、「SoundGenerator 機能を使用するかどうか」を指定します。デフォルトは `false` です。第2引数は、SoundGenerator 機能を使用する際のバッファサイズを指定します。第1引数が `false` であれば指定しなくても良いです。

### イントロ付き無限ループ機能
このライブラリの目玉といえる機能です。主にゲームなどの「コンテンツの BGM 」で使える機能です。

#### まずは「登録用データ」を作成
```
var soundObject:Sound = new Sound(...);
var bgmRegister:RegisterSoundInfo = new RegisterSoundInfo(soundObject, true);
```

登録用データは `RegisterSoundInfo` オブジェクトを使用します。コンストラクタにサウンドオブジェクトを指定します。
第2引数は、PCM の `ByteArray` を作成するかを指定します。これを `true` にすると、`Sound` オブジェクトから PCM の `ByteArray` を作成します。無限ループは SoundGenerator 機能を使用するため、このパラメータは `true` にする必要があります。

#### SoundConductor に登録
```
var soundId:SoundId = SoundConductor.registerSound(bgmRegister);
```

先ほどの登録用データを、`SoundConductor` に登録します。登録すると、`SoundId` オブジェクトが返されます。これが、登録したサウンドに紐づいた ID となり、この ID を使用してサウンドの再生を行うことになります。

#### 「再生用データ」を作成
```
var bgmPlayInfo:SoundPlayInfo = new SoundPlayInfo(soundId);
bgmPlayInfo.soundPlayType = SoundPlayType.SINGLE_SOUND_GENERATOR;
bgmPlayInfo.loops = SoundLoopType.INFINITE_LOOP;
bgmPlayInfo.startTimeByMS = 500;	// 500ms の部分から開始
bgmPlayInfo.loopStartTimeByMS = 7991;	// ループの際は、7991ms の部分からループ開始
bgmPlayInfo.loopEndTimeByMS = 107650;	// 107650ms になったらループ開始位置まで戻る
```

再生用データは、`SoundPlayInfo` オブジェクトを使用します。先ほど登録した際に入手した `soundId` を指定します。

`soundPlayType` プロパティは、「どういった機能を用いてサウンド再生を行うか」を指定する大事なパラメータです。`SoundPlayType.SINGLE_SOUND_GENERATOR` は一つのサウンドに付き一つの SoundGenerator（`Sound` オブジェクト）を生成し、利用します。この詳細は後述しています。

このオブジェクトでは、上記のように、再生情報をプロパティとして指定します。内容は上記コードのコメントを参考ください。

#### 再生
```
var bgmController:SoundController = SoundConductor.play(bgmPlayInfo);
```

先ほど作成した「再生用データ」を用いて、`SoundConductor` で再生を行います。これで「500ms から再生を開始し、107650ms に到達したら、7991ms に戻ってループ再生を行うという「イントロ付き無限ループ」が実現されます。

`SoundController` は、AS3 の `Sound` クラスにおける `SoundChannel` と同じ意味合いを持ちます。このコントローラクラスを用いて、一時停止やボリューム調整を行います。

#### 無限ループ使用の注意点
稀に、上記の設定を行っても無限ループがされない場合があります。その際は、ループの時間を少しだけ前後させてみてください。ループが機能する可能性があります。

この件についての原因は不明です。

### SoundGenerator 機能を使う際の注意点
- 音質が変化する場合があります。
- SoundGenerator の特性上、再生開始と終了にラグが生じます。
- PCM の `ByteArray` を使うため、メモリの使用量が相当にあります。特にサウンドが長ければ長いほど顕著になります。モバイルなどで扱う場合はこれが原因でアプリ自体が落ちる可能性もあります。ご注意ください。
- 大量に使うと、サウンド生成の処理が多量に走るため、パフォーマンスに影響する可能性があります。

### サウンド再生の種類
`SoundConductor` においてサウンドを登録する際、3パターンの再生手法を選択することが出来ます。
- `SoundPlayType.NORMAL_SOUND_ARCHITECT`
- `SoundPlayType.SINGLE_SOUND_GENERATOR`
- `SoundPlayType.SHARED_SOUND_GENERATOR`

`SoundPlayType.NORMAL_SOUND_ARCHITECT` は、通常の `Sound` をそのまま登録し、再生を行います。そのため、挙動は `Sound` クラスそのものです。そのため、「イントロ付き無限ループ」を行うことも出来ません。（通常の単純なループは可能です）

`SoundPlayType.SINGLE_SOUND_GENERATOR` は、登録する一つのサウンドに対して、一つの `Sound` オブジェクトを割り当て、そこで SoundGenerator を使用します。SoundGenerator を使うのであれば、この再生手法を使うのがベターです。ボリューム変更とパン変更も `SoundChannel` の機能を使うので、適用は早いです。

`SoundPlayType.SHARED_SOUND_GENERATOR` は、共用の SoundGenerator を使用し、一つ以上のサウンドを合成して再生します。そのため、`SoundChannel` による同時発音数の制限はありません。但し、そもそも SoundGenerator を使うには PCM の `ByteArray` 化を行う必要があるので、複数同時に扱う場合はメモリが大量に必要になります。また、この手法はボリューム変更とパン変更を波形を弄って行わなければならないため、必然的にタイムラグが発生します。

### サウンドのグルーピング機能
例えばゲームなどでよくあるのが、BGM、効果音、ボイスなどをカテゴリーごとに制御するという仕様です。`SoundConductor` では、グループ機能というのを扱うことにより、グループごとのサウンド制御を可能にします。

`SoundConductor.createGroup()` を使用し、`SoundGroupController` をオブジェクトを取得します。このコントローラを使用し、グループの再生の制御を行います。

再生するサウンドをグループに紐づけたい場合は、`SoundConductor.createGroup()` を扱う際に登録する「グループ名」を、`SoundConductor.play()` の引数に渡すことで可能です。

### 登録を行わない再生手法
今までは「登録を行うことで管理をする」という手法に基づいて説明してきました。しかし、そんなに何度も使わないようなちょっとしたサウンドに対して、いちいち登録を行うというのは面倒なものです。

`SoundConductor` では、「管理は行わず、現在制御している音量を元にサウンドの再生を行う」だけの再生手法を用意しました。`SoundConductor.playSoundObject()` を使用します。

これは本当に単純に、マスターボリュームと、場合によってはグループのボリュームを換算して、普通に `Sound` を鳴らすというものです。ですので、戻り値は `SoundController` ではなく、`SoundChannnel` となります。`SoundConductor` では管理されないため、再生した後は、`SoundConductor` による制御は適用されません。

### MovieClip などの「サウンドを内包するコンテンツ」への音量の適用
MovieClip などは、その中のコンテンツにサウンドを適用し、再生することが可能です。これに対して `SoundConductor` で管理されている音量を適用したい場合は、`SoundConductor.setVolumeToObject()` を使用してください。`SoundConductor.playSoundObject()` と同様、`SoundConductor` で管理されているマスターボリュームと、場合によってはグループのボリュームを適用することが出来ます。

### 弱参照のサウンド再生
Flash には最大同時発音数の制限があります。それを超えた場合、追加しようとしたサウンドは再生できません。どれか一つを停止する必要があります。

`SoundConductor` では「weakReference（弱参照のサウンド再生）」機能を実装しており、最大発音数を超えたサウンドを鳴らそうとした際に、弱参照として再生しているサウンドを停止し、自動的に発音数を下げる機構を持っています。特に SE など短い音が大量に鳴る場合に有効です。

サウンドを再生する際に使用する `SoundPlayInfo` の `weakReference` を `true` に設定すると、弱参照としてサウンド再生を行います。デフォルトは `false` です。再生しているサウンドが全て弱参照では無い場合、再生はされません。
