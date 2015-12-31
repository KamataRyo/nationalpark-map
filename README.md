# Online National Park Map / 国立公園オンラインマップ

[![Build Status Images](https://travis-ci.org/KamataRyo/nationalpark-map.svg)](https://travis-ci.org/KamataRyo/nationalpark-map)
[![codecov.io](https://codecov.io/github/KamataRyo/nationalpark-map/coverage.svg?branch=master)](https://codecov.io/github/KamataRyo/nationalpark-map?branch=master)

## Abstract / 概要

National park map in Japan (restriction area)

日本の国立公園（規制区域）の区域図です。

## How does it work? / どんなものか？

![screen shot](screenshot.png)

The developmental restricted areas of national park are overlaid on Google Maps.
You can share the view with anyone via URL, which is rewritten synchronous to change of view.

国立公園の開発規制区域がGoogle Maps上に表示されます。
URLは表示の変化に応じて書き換えられ、現在の表示を人と共有できます。

## Purpose of this project / このプロジェクトの目的

Provide a platform to share geolocational information of Japanese National Park.

日本の国立公園について、その地理情報を共有するためのプラットフォームを提供することです。

## Goal of the development / 開発のゴール

- (incomplete) Auto-transformation of national from official KML to TopoJSON with gulp.
- (done) Overlay national park poligon on Webmap service.
- (done) Support geolocation.
- Apply test in high coverage and keep code maintainable.


- (不完全) gulpを使い、公式に提供されているKMLファイルからTopoJSONを生成するコンバーターを作成すること
- (完了) 国立公園のポリゴンをウェブマップのサービスにオーバレイできること
- (完了) ジオローケーションをサポートすること
- 高カバレッジのユニットテストを作成し、コードをメンテナブルに保つこと

## License / ライセンス
MIT

### Attention / 注意事項
TopoJSONs are under another License.
See [topojson/LICENSE.md](topojson/LICENSE.md).

TopoJSONファイルは他のライセンス（政府標準利用規約）下にあると思われます。
[topojson/LICENSE.md](topojson/LICENSE.md)をご覧下さい。
