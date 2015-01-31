---
---

createInfoWindowContent = (attraction) ->
	"<h1>#{attraction['name']}</h1>
	<p>#{attraction['description']}</p>
	<a href='#{attraction['url']}' target='_blank'>View Website</a><br/>
	Directions: <a
	href='https://www.google.com/maps?saddr=My+Location&daddr=#{attraction['coordinates'].lat},#{attraction['coordinates'].lng}'>
	Google</a> | <a href='http://maps.apple.com/?daddr=#{attraction['coordinates'].lat},#{attraction['coordinates'].lng}'>
	Apple</a>"

createInlineWindowContent = (attraction) ->
	"<a href='#{attraction['url']}' target='_blank'>#{attraction['name']}</a>
	<p>#{attraction['description']}</p>"

toggleDisplay = (attraction, marker, div) ->
	div.toggleClass "marker-selected"

	unless marker.my_infowindow?
		marker['my_infowindow'] = new google.maps.InfoWindow
			content: createInfoWindowContent attraction
			maxWidth: 320

		marker.my_infowindow.open marker.map, marker
	else
		marker.my_infowindow.close
		delete marker.my_infowindow

addMarkerDesc = (attraction, marker, markersDiv) ->
	newDiv = $(
		'<div/>',
		class: 'marker-div'
	)
	newDiv.click ->
		toggleDisplay attraction, marker, newDiv

	$(createInlineWindowContent attraction).appendTo newDiv

	newDiv.appendTo markersDiv
	return newDiv

get_next_marker_icon = (current_num) ->
	icons = ["purple", "yellow", "green"]
	"http://maps.google.com/mapfiles/ms/icons/#{icons[current_num]}-dot.png"

initialize = ->
	mapOptions =
		center: new google.maps.LatLng 42.004845, -87.886333
		zoom: 13

	map = new google.maps.Map $("#map-canvas")[0], mapOptions

	markersDiv = $("#map-markers")
	current_marker_icon = -1

	$.getJSON "/attraction_info.json", (data) ->
		$.each data, (cat, attractions) ->
			current_marker_icon++
			$("<h3>#{cat}</h3>").appendTo "#map-markers"

			for attraction in attractions
				marker = new google.maps.Marker
					position: attraction["coordinates"]
					map: map
					title: attraction["name"]
					icon: get_next_marker_icon(current_marker_icon)

				markerDiv = addMarkerDesc attraction, marker, markersDiv

				google.maps.event.addListener marker, 'click', ->
					toggleDisplay attraction, marker, markerDiv


google.maps.event.addDomListener window, 'load', initialize
