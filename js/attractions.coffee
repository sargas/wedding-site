---
---

toggleDisplay = (attraction, marker, div) ->
	div.toggleClass("marker-selected")
	infoWindow = new google.maps.InfoWindow
		content: attraction['description']
	unless marker.my_infowindow?
		infoWindow.open(marker.map, marker)
		marker['my_infowindow'] = infoWindow
	else
		marker.my_infowindow.close()
		delete marker.my_infowindow

addMarkerDesc = (attraction, marker) ->
	markersDiv = $("#map-markers")
	newDiv = $(
		'<div/>',
		class: 'marker-div'
	)
	newDiv.click ->
		toggleDisplay(attraction, marker, newDiv)
	$(
		'<a/>',
		text: attraction['name']
	).appendTo(newDiv)

	newDiv.appendTo(markersDiv)
	return newDiv

initialize = ->
	mapOptions =
		center: new google.maps.LatLng(42.004845, -87.886333)
		zoom: 13
	
	map = new google.maps.Map($("#map-canvas")[0], mapOptions)

	$.getJSON "/attraction_info.json", (data) ->
		$.each data, (cat, attractions) ->
			for attraction in attractions
				marker = new google.maps.Marker
					position: attraction["coordinates"]
					map: map
					title: attraction["name"]
				markerDiv = addMarkerDesc(attraction,marker)

				google.maps.event.addListener(marker, 'click', ->
					toggleDisplay(attraction, marker, markerDiv)
				)

google.maps.event.addDomListener(window, 'load', initialize)
