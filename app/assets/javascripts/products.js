$(window).load(function() {
  return $('a[data-target]').click(function(e) {
    var $this, new_icon, new_target, old_icon, url;
    e.preventDefault();
    $this = $(this);
    if ($this.data('target') === 'Add to') {
      url = $this.data('addurl');
      new_target = "Remove from";
      new_icon = "fa-times";
      old_icon = "fa-shopping-cart";
    } else {
      url = $this.data('removeurl');
      new_target = "Add to";
      new_icon = "fa-shopping-cart";
      old_icon = "fa-times";
    }
    return $.ajax({
      url: url,
      type: 'put',
      success: function(data) {
        $('.cart-count').html(data);
        $this.find('span').html(new_target);
        $this.find('i').addClass(new_icon).removeClass(old_icon);
        return $this.data('target', new_target);
      }
    });
  });
});

function Slider( element ) {
	this.el = document.querySelector( element );
	this.init();
}

Slider.prototype = {
	init: function() {
		this.links = this.el.querySelectorAll( "#slider-nav a" );
		this.wrapper = this.el.querySelector( "#slider-wrapper" );
		this.navigate();
	},
	navigate: function() {

		for( var i = 0; i < this.links.length; ++i ) {
			var link = this.links[i];
			this.slide( link );
		}
	},

	animate: function( slide ) {
		var parent = slide.parentNode;
		var caption = slide.querySelector( ".caption" );
		var captions = parent.querySelectorAll( ".caption" );
		for( var k = 0; k < captions.length; ++k ) {
			var cap = captions[k];
			if( cap !== caption ) {
				cap.classList.remove( "visible" );
			}
		}
		caption.classList.add( "visible" );
	},

	slide: function( element ) {
		var self = this;
		element.addEventListener( "click", function( e ) {
			e.preventDefault();
			var a = this;
			self.setCurrentLink( a );
			var index = parseInt( a.getAttribute( "data-slide" ), 10 ) + 1;
			var currentSlide = self.el.querySelector( ".slide:nth-child(" + index + ")" );

			self.wrapper.style.left = "-" + currentSlide.offsetLeft + "px";
			self.animate( currentSlide );

		}, false);
	},
	setCurrentLink: function( link ) {
		var parent = link.parentNode;
		var a = parent.querySelectorAll( "a" );

		link.className = "current";

		for( var j = 0; j < a.length; ++j ) {
			var cur = a[j];
			if( cur !== link ) {
				cur.className = "";
			}
		}
	}
};

document.addEventListener( "DOMContentLoaded", function() {
	var aSlider = new Slider( "#slider" );

});
