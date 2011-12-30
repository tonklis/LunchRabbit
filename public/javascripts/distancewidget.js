function DistanceWidget(opt_options) {
  var options = opt_options || {};

  this.setValues(options);

  if (!this.get('position')) {
    this.set('position', map.getCenter());
  }

  // Add a marker to the page at the map center or specified position
  var marker = new google.maps.Marker({
    draggable: true,
    title: 'Move me!'
  });

  marker.bindTo('map', this);
  marker.bindTo('zIndex', this);
  marker.bindTo('position', this);
  marker.bindTo('icon', this);

  // Create a new radius widget
  var radiusWidget = new RadiusWidget(options['distance']);

  // Bind the radius widget properties.
  radiusWidget.bindTo('center', this, 'position');
  radiusWidget.bindTo('map', this);
  radiusWidget.bindTo('zIndex', marker);
  radiusWidget.bindTo('maxDistance', this);
  radiusWidget.bindTo('minDistance', this);

  // Bind to the radius widget distance property
  this.bindTo('distance', radiusWidget);
  // Bind to the radius widget bounds property
  this.bindTo('bounds', radiusWidget);
}
DistanceWidget.prototype = new google.maps.MVCObject();


function RadiusWidget(opt_distance) {
  var circle = new google.maps.Circle({
    strokeWeight: 2
  });

  this.set('distance', opt_distance);
  this.set('active', false);
  this.bindTo('bounds', circle);

  circle.bindTo('center', this);
  circle.bindTo('zIndex', this);
  circle.bindTo('map', this);
  circle.bindTo('radius', this);

  this.addSizer_();
}
RadiusWidget.prototype = new google.maps.MVCObject();


RadiusWidget.prototype.distance_changed = function() {
  this.set('radius', this.get('distance') * 1000);
};

RadiusWidget.prototype.addSizer_ = function() {
  var sizer = new google.maps.Marker({
    draggable: true,
    title: 'Drag me!',
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

RadiusWidget.prototype.center_changed = function() {
  var sizerPos = this.get('sizer_position');
  var position;
  if (sizerPos) {
    position = this.getSnappedPosition(sizerPos);
  } else {
    var bounds = this.get('bounds');
    if (bounds) {
      var lng = bounds.getNorthEast().lng();
      position = new google.maps.LatLng(this.get('center').lat(), lng);
    }
  }

  if (position) {
    this.set('sizer_position', position);
  }
};

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
  
  var newPos = this.getSnappedPosition(pos);
  this.set('sizer_position', newPos);
 };
 
RadiusWidget.prototype.getSnappedPosition = function(pos) {
  var bounds = this.get('bounds');
  var center = this.get('center');
  var left = new google.maps.LatLng(center.lat(),
      bounds.getSouthWest().lng());
  var right = new google.maps.LatLng(center.lat(),
      bounds.getNorthEast().lng());

  var leftDist = this.distanceBetweenPoints_(pos, left);
  var rightDist = this.distanceBetweenPoints_(pos, right);

  if (leftDist < rightDist) {
    return left;
  } else {
    return right;
  }
};
