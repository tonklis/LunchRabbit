function DistanceWidget(opt_options) {
	var options = opt_options || {};
	//this.setValues(options);
	
	if (!this.get('position')) {
		this.set('position', map.getCenter());
	}

	var marker = new google.maps.Marker({
		draggable: true,
		title: 'Place me at your location'
	});
	
	marker.bindTo('map', this);
	marker.bindTo('zIndex', this);
	marker.bindTo('position', this);
	marker.bindTo('icon', this);
	
	// Create a new radius widget
	var radiusWidget = new RadiusWidget(options['distance'] || 3);
	// Bind the radius widget properties.
	radiusWidget.bindTo('center', this, 'position');
	radiusWidget.bindTo('map', this);
	radiusWidget.bindTo('zIndex', marker);
	radiusWidget.bindTo('maxDistance', this);
	radiusWidget.bindTo('minDistance', this);
	
	// Bind to the radiusWidgets' distance property
	this.bindTo('distance', radiusWidget);
	// Bind to the radiusWidgets' bounds property
	this.bindTo('bounds', radiusWidget);
	}	
DistanceWidget.prototype = new google.maps.MVCObject();

function RadiusWidget(opt_distance) {
	var circle = new google.maps.Circle({
		strokeWeight: 2
	});

	this.set('distance', opt_distance);
	this.bindTo('bounds', circle);
	
	circle.bindTo('center', this);
	circle.bindTo('zIndex', this);
	circle.bindTo('map', this);
	circle.bindTo('radius', this);

	this.addSizer_();
}
RadiusWidget.prototype = new google.maps.MVCObject();

/**
 * Update the radius when the distance has changed.
 */
RadiusWidget.prototype.distance_changed = function() {
	this.set('radius', this.get('distance') * 1000);
};

/**
 * Add the sizer marker to the map.
 */
RadiusWidget.prototype.addSizer_ = function() {
	var sizer = new google.maps.Marker({
		draggable: true,
		title: 'Increase/Decrease the radius',
		raiseOnDrag: false
	});

	sizer.bindTo('zIndex', this);
	sizer.bindTo('map', this);
	sizer.bindTo('icon', this);
	sizer.bindTo('position', this, 'sizer_position');
	
	var me = this;
	google.maps.event.addListener(sizer, 'drag', function() {
		// Set the circle distance (radius)
		me.setDistance();
	});
};

/**
 * Update the center of the circle and position the sizer back on the line.
 *
 * Position is bound to the DistanceWidget so this is expected to change when
 * the position of the distance widget is changed.
 */
RadiusWidget.prototype.center_changed = function() {
	var bounds = this.get('bounds');
	// Bounds might not always be set so check that it exists first.
	if (bounds) {
		var lng = bounds.getNorthEast().lng();
		// Put the sizer at center, right on the circle.
		var position = new google.maps.LatLng(this.get('center').lat(), lng);
		this.set('sizer_position', position);
	}
};

/**
 * Calculates the distance between two latlng locations in km.
 * @see http://www.movable-type.co.uk/scripts/latlong.html
 *
 * @param {google.maps.LatLng} p1 The first lat lng point.
 * @param {google.maps.LatLng} p2 The second lat lng point.
 * @return {number} The distance between the two points in km.
 * @private
*/
RadiusWidget.prototype.distanceBetweenPoints_ = function(p1, p2) {
	if (!p1 || !p2) {
		return 0;
	}

	var R = 6371; // Radius of the Earth in km
	var dLat = (p2.lat() - p1.lat()) * Math.PI / 180;
	var dLon = (p2.lng() - p1.lng()) * Math.PI / 180;
	var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
		Math.cos(p1.lat() * Math.PI / 180) * Math.cos(p2.lat() * Math.PI / 180) *
		Math.sin(dLon / 2) * Math.sin(dLon / 2);
	var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
	var d = R * c;
	return d;
};


/**
 * Set the distance of the circle based on the position of the sizer.
 */
RadiusWidget.prototype.setDistance = function() {
	// As the sizer is being dragged, its position changes.  Because the
	// RadiusWidget's sizer_position is bound to the sizer's position, it will
	// change as well.
	var pos = this.get('sizer_position');
	var center = this.get('center');
	var distance = this.distanceBetweenPoints_(center, pos);
	
	if (this.get('maxDistance') && distance > this.get('maxDistance')) {
		distance = this.get('maxDistance');
	}

	if (this.get('minDistance') && distance < this.get('minDistance')) {
		distance = this.get('minDistance');
	}
	
	// Set the distance property for any objects that are bound to it
	this.set('distance', distance);
};