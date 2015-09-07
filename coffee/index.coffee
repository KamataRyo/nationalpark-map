map = null#googlemapオブジェクトを格納
geojsonLoaded = {}#マップへの読み込み済みgeojsonを判別する
abstract = null# geojsonのabstractを読み込む
loadingque = []#geojsonの読み込み状態を管理
areaPin = null#エリアをピン留めするときのマーカー

# googlemapの初期設定
initialize = () ->
	$map = $ '#map-canvas'
	options =
		noClear : true
		center : new google.maps.LatLng 35.127152, 138.910627
		zoom : 10
		panControl: false
		zoomControl: false
		mapTypeControl: true
		scaleControl: true
		streetViewControl: true
		overviewMapControl: false
	map = new google.maps.Map $map[0], options
	map.addListener 'idle', () ->
		if $('#auto-overlay').is ':checked' then geojsonAutoload()

#地種区分ごとの色を定義
gradeFill =
    "特別保護地区": "#dddd66"
    "海域公園地区": "#2233dd"
    "海中公園地区": "#2233dd"
    "第1種特別地域": "#dd66dd"
    "第2種特別地域": "#dd6666"
    "第3種特別地域": "#66dd66"
    "普通地域": "#66dddd"
    "else": "#666666"

# geojsonフィーチャーの地種とそれに対するイベントから適応するスタイルを決定する
featureStyle = (state, grade) ->
	result =
		strokeColor: '#eeeeee'
		strokeWeight: 1
		fillOpacity: 0.4
	if grade?
		result.fillColor = gradeFill[grade]
	if state is 'mouseover'
		strokeColor: '#ffffaa'
		result.fillOpacity = 0.7
		result.strokeWeight = 2.5
	return result

#読み込み中の状態表示
changeLoadingState = (loadStateID, state) ->
	if state is 'start'
		loadingque.push loadStateID
		$('#load-statement').addClass 'fa-spin'
	else if 'finish'
		loadingque.pop loadStateID
		if loadingque.length is 0
			$('#load-statement').removeClass 'fa-spin'


# geojson layerの追加と設定
loadGeojson = (url) ->
	if geojsonLoaded[url]
		return false
	else
		geojsonLoaded[url] = true
	changeLoadingState url,'start'
	$.getJSON url, (json) ->
		map.data.addGeoJson json
		map.data.setStyle (feature) ->
			grade = feature.getProperty('grade')
			return featureStyle '', grade
		changeLoadingState url,'finish'

		updatePinningInformation = (e, active) ->
			if active
				npname = e.feature.getProperty 'name'
				grade = e.feature.getProperty 'grade'
				$('#display-np').val "#{npname}国立公園"
				$('#display-grade').val grade
				$('#np-statement').css 'color', 'red'
				$('#grade-statement').css 'color', 'red'
			else
				$('#display-np').val ''
				$('#display-grade').val ''
				$('#np-statement').css 'color', 'black'
				$('#grade-statement').css 'color', 'black'

		map.data.addListener 'mouseover', (e) ->
			if !areaPin then updatePinningInformation e, true
			map.data.overrideStyle e.feature, featureStyle 'mouseover'

		map.data.addListener 'click', (e) ->
			if areaPin?
				#marker取り除き
				areaPin.setMap null
				areaPin = null
				#marker追加
			opt =
				position: e.latLng
				map: map
				clickable: true
				cursor: 'crosshair'
			areaPin = new google.maps.Marker opt
			areaPin.addListener 'click', (e) ->
				areaPin.setMap null
				areaPin = null
			updatePinningInformation e, true

		map.data.addListener 'mouseout', (e) ->
			if !areaPin then updatePinningInformation null, false
			map.data.overrideStyle e.feature, featureStyle()


#現在の座標位置をもとに、範囲内のgeojsonを全て読み込む
geojsonAutoload = () ->
	if !abstract then return false
	margin = 0.1#margin = 10%
	top = map.getBounds().getNorthEast().G
	right = map.getBounds().getNorthEast().K
	bottom = map.getBounds().getSouthWest().G
	left = map.getBounds().getSouthWest().K
	top += (1 + margin) * (top - bottom)
	right += (1 + margin) * (right - left)
	bottom -= (1 + margin) * (top - bottom)
	left -= (1 + margin) * (right - left)

	for geojson, information of abstract
		c1 = information.top > bottom
		c2 = information.bottom < top
		c3 = information.right > left
		c4 = information.left < right
		if c1 and c2 and c3 and c4
			loadGeojson 'geojson/' + geojson

$('#auto-overlay').change () ->
	state = $(this).is ':checked'
	if state is true then geojsonAutoload()

#現在地にpanする
$('#move-to-current').click () ->
	theClass = $('#geolocation-statement').attr 'class'
	result = false
	if navigator.geolocation
		navigator.geolocation.getCurrentPosition (pos) ->
			$('#geolocation-statement')
				.removeClass theClass
				.addClass 'fa fa-check-circle'
				.css 'color', 'green'
			map.panTo new google.maps.LatLng pos.coords.latitude, pos.coords.longitude
		,(e) ->
			$('#geolocation-statement')
				.removeClass theClass
				.addClass 'fa fa-plus-circle fa-rotate-45'
				.css 'color', 'red'
			console.log '現在地取得エラー:' + e
	else
		$('#geolocation-statement')
			.removeClass theClass
			.addClass 'fa fa-exclamation-triangle'
			.css 'color', 'yellow'
		console.log '位置情報使用不可'


# toggle機能の定義
##toggleアイコンをprepend
##初期状態でtoggleにするにはstyle=display:none
$('.toggle-next').each (i, elem) ->
	$(elem).prepend '<i class="fa"></i>'
	$i = $(elem).children 'i'
	display = $(elem).next().css 'display'
	if display is 'none'
		$i.addClass 'fa-angle-double-right'
	else
		$i.addClass 'fa-angle-double-down'

## toggleの動作の定義
$('.toggle-next').click () ->
	display = $(this).next().css 'display'
	if display is 'none'
		$(this).children('i')
			.removeClass 'fa-angle-double-right'
			.addClass 'fa-angle-double-down'
		$(this).next().show 'fast'
	else
		$(this).children('i')
			.removeClass 'fa-angle-double-down'
			.addClass 'fa-angle-double-right'
		$(this).next().hide 'fast'


$.getJSON './geojson/abstract.json', (json) ->
	# selectboxに反映
	abstract = json#globalにも格納
	for url, information of json
		$('<option>')
			.appendTo $ '#handy-overlay'
			.val url
			.text information.name
	$('#handy-overlay').change () ->
		basename = $(this).val()
		if basename is '' then return false
		url = 'geojson/' + basename
		loadGeojson url
		#中心座標へ移動
		Clat = (json[basename].top + json[basename].bottom) / 2
		Clon = (json[basename].right + json[basename].left) / 2
		geojsonCenter = new google.maps.LatLng Clat, Clon
		map.panTo geojsonCenter


initialize()
