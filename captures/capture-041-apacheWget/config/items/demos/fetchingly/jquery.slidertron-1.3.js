/*
	Slidertron 1.3: A flexible slider plugin for jQuery
	By n33 | http://n33.co | @n33co
	Dual licensed under the MIT or GPLv2 license.
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	MIT LICENSE:
	Copyright (c) 2012 n33, http://n33.co
	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following conditions:
	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	GPLv2 LICENSE:
	Copyright (c) 2012 n33, http://n33.co
	This program is free software: you can redistribute it and/or modify it	under the terms of the GNU General Public License as
	published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version. This program is
	distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
	or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of
	the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>. 
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

(function(jQuery) {

	jQuery.fn.disableSelection_slidertron = function() { return jQuery(this).css('user-select', 'none').css('-khtml-user-select', 'none').css('-moz-user-select', 'none').css('-o-user-select', 'none').css('-webkit-user-select', 'none'); }

	jQuery.fn.slidertron = function(options) {
		
		var settings = jQuery.extend({
			selectorParent:		jQuery(this)
		}, options);
		
		return jQuery.slidertron(settings);
	}

	jQuery.slidertron = function(options) {

		// Settings
		
			var settings = jQuery.extend({
			
				selectorParent:						null,		// If a jQuery object, all selectors will be restricted to its scope. Otherwise, all selectors will be global.

				// Selectors

					viewerSelector:					null,		// Viewer selector
					reelSelector:					null,		// Reel selector
					slidesSelector:					null,		// Slides selector
					indicatorSelector:				null,		// Indicator selector
					jumpLinksSelector:				null,		// Jump links selector
					navNextSelector:				null,		// 'Next' selector
					navPreviousSelector:			null,		// 'Previous' selector
					navFirstSelector:				null,		// 'First' selector
					navLastSelector:				null,		// 'Last' selector
					navStopAdvanceSelector:			null,		// 'Stop Advance' selector
					navPlayAdvanceSelector:			null,		// 'Play Advance' selector
					captionLineSelector:			null,		// 'Caption Line' selector
					slideLinkSelector:				null,		// 'Slide Link' selector
					slideCaptionSelector:			null,		// 'Slide Caption' selector

				// General settings

					mode:							'fade',	// Slider mode ('slide', 'fade', 'fadeIn')
					speed:							'fast',		// Transition speed (0 for instant, 'slow', 'fast', or a custom duration in ms)
					fadeInSpeed:					'slow',		// Speed at which to fade in the reel on page load (0 for instant, 'slow', 'fast', or a custom duration in ms)
					navWrap:						true,		// Wrap navigation when we navigate past the first or last slide
					seamlessWrap:					true,		// Seamlessly wrap slides
					advanceDelay:					0,			// Time to wait (in ms) before automatically advancing to the next slide (0 disables advancement entirely)
					advanceWait:					0,			// Time to wait before starting automatic advancement
					advanceNavActiveClass:			'active',	// Class applied to active stop/play navigation control
					advanceDirection:				'forward',	// Direction to advance ('forward', 'backward', 'random')
					viewerOffset:					false,		// Viewer offset amount	(+ = shift right, - = shift left, 0 = do nothing, false = disable)	
					activeSlideClass:				'active',	// Class applied to the active slide
					disabledNavClass:				'disabled',	// Class applied to disabled navigation controls
					clickToNav:						false,		// Navigate to a slide when clicked (used in conjunction with viewerOffset)
					captionLines:					0,			// Number of caption lines. If this is > 1, the plugin will look for additional caption elements using the captionSelector setting + a number (eg. '.caption2', '.caption3', etc.)
					autoHideNav:					false,		// Automatically hides the navigation buttons if they're not needed
					autoFit:						false,		// Automatically sets the width and height of the slider based on available space (requires autoFitAspectRatio)
					autoFitAspectRatio:				0.5,		// Used by autoFit to determine the slider's dimensions (value is width / height)
					initialSlide:					1,			// Initial slide (a number or 'random' for a random slide)
					hashJump:						false,		// If true, slider will start at the slide pointed to by the ID given by the URL hashmark (eg. #something)
					hashJumpStopAdvance:			true,		// If true (and hashJump is enabled), slider will begin in a stopped state when a hashmark is detected
					activeJumpLinkClass:			'active',	// Class applied to the active jump link
					arrowsToNav:					false,		// If true, the left/right arrow keys will be used for navigation
					blurOnChange:					false,		// If true, defocuses any input elements on slide change
					navSize:						1,			// ...

				// Callbacks
				
					onSlideSwitch:					false

			}, options);

		// Variables

			// Operational stuff
		
				var isConfigured = true,
					isLocked = false,
					isAdvancing = false,
					isSeamless = false,
					list = new Array(),
					currentIndex = false,
					timeoutID,
					pFirst,
					pLast;

				var _isTouch = !!('ontouchstart' in window), _eventType = (_isTouch ? 'touchend' : 'click');

			// jQuery objects

				var __slides,
					__viewer,
					__reel,
					__indicator,
					__navFirst,
					__navLast,
					__navNext,
					__navPrevious,
					__navStopAdvance,
					__navPlayAdvance,
					__captionLines,
					__navControls = new Array(),
					__jumpLinks;

		// Functions
			
			function getElement(selector, required, global)
			{
				var x;
				
				try
				{
					if (selector == null)
						throw 'is undefined';
			
					if (settings.selectorParent && !global)
						x = settings.selectorParent.find(selector);
					else
						x = jQuery(selector);
					
					if (x.length == 0)
						throw 'does not exist';

					x.disableSelection_slidertron();

					return x;
				}
				catch (error)
				{
					if (required == true)
					{
						alert('Error: Required selector "' + selector + '" ' + error + '.');
						isConfigured = false;
					}
				}
				
				return null;
			}

			function advance()
			{
				if (settings.advanceDelay == 0)
					return;
			
				if (!isLocked)
				{
					switch (settings.advanceDirection)
					{
						case 'random':
						
							var x = __slides.length - 1, y;
							
							if (settings.seamlessWrap && settings.mode == 'slide')
								x -= 3;

							if (x < 2)
								break;
							
							while ( (y = Math.ceil(Math.random() * x)) == currentIndex ) { }
							
							switchSlide(y);

							break;
					
						case 'backward':
							previousSlide();
							break;
					
						case 'forward':
						default:
							nextSlide();
							break;
					}
				}

				timeoutID = window.setTimeout(advance, settings.advanceDelay);
			}

			function initializeAdvance()
			{
				if (settings.advanceDelay == 0)
					return;

				if (__navStopAdvance)
					__navStopAdvance.addClass(settings.advanceNavActiveClass);
				
				if (__navPlayAdvance)
					__navPlayAdvance.removeClass(settings.advanceNavActiveClass);

				isAdvancing = true;
				timeoutID = window.setTimeout(advance, settings.advanceDelay);
			}
			
			function interruptAdvance()
			{
				stopAdvance();
			}
			
			function stopAdvance()
			{
				if (settings.advanceDelay == 0)
					return;

				if (!isAdvancing)
					return;

				if (__navStopAdvance && __navPlayAdvance)
				{
					__navStopAdvance.removeClass(settings.advanceNavActiveClass);
					__navPlayAdvance.addClass(settings.advanceNavActiveClass);
				}
			
				isAdvancing = false;
				window.clearTimeout(timeoutID);
			}
			
			function playAdvance(skip)
			{
				if (settings.advanceDelay == 0)
					return;

				if (isAdvancing)
					return;
					
				isAdvancing = true;

				if (__navStopAdvance && __navPlayAdvance)
				{
					__navPlayAdvance.removeClass(settings.advanceNavActiveClass);
					__navStopAdvance.addClass(settings.advanceNavActiveClass);
				}

				if (skip)
					timeoutID = window.setTimeout(advance, settings.advanceDelay);
				else
					advance();
			}
			
			function getSlideById(id)
			{
				var x;

				for (x in list)
				{
					if (list[x].id == id)
						return x;
				}
				
				return false;
			}
			
			function firstSlide()
			{
				switchSlide(pFirst);
			}
			
			function lastSlide()
			{
				switchSlide(pLast);
			}

			function nextSlide()
			{
				var x = false;
				
				if ((isSeamless && currentIndex <= pLast)
				||	(!isSeamless && currentIndex < pLast))
					x = parseInt(currentIndex) + settings.navSize;
				else if (settings.navWrap || isAdvancing)
					x = pFirst;
				
				if (x > pLast)
					x = pLast;
				else if (x < 0)
					x = 0;
				
				if (x !== false)
					switchSlide(x);
			}
			
			function previousSlide()
			{
				var x = false;

				if ((isSeamless && currentIndex >= pFirst)
				||	(!isSeamless && currentIndex > pFirst))
					x = parseInt(currentIndex) - settings.navSize;
				else if (settings.navWrap)
					x = pLast;
					
				if (x > pLast)
					x = pLast;
				else if (x < 0)
					x = 0;
				
				if (x !== false)
					switchSlide(x);
			}

			function updateJumpLink(index)
			{
				if (!__jumpLinks
				||	!list[index].jumpLink)
					return;
				
				__jumpLinks.removeClass(settings.activeJumpLinkClass);
				list[index].jumpLink.addClass(settings.activeJumpLinkClass);
			}

			function updateURL()
			{
				if (!settings.hashJump
				||	!list[currentIndex].id)
					return;

				if (currentIndex != pFirst)
					window.location.replace('#' + list[currentIndex].id);
				else
					window.location.replace('#');
			}

			function updateNavControls()
			{
				if (settings.disabledNavClass === false
				||	settings.navWrap === true)
					return;
				
				for (x in __navControls)
					if (__navControls[x])
						__navControls[x].removeClass(settings.disabledNavClass).css('cursor', 'pointer');

				var tmp = new Array();

				if (currentIndex == pFirst)
				{
					tmp.push(__navFirst);
					tmp.push(__navPrevious);
				}
				
				if (currentIndex == pLast)
				{
					tmp.push(__navLast);
					tmp.push(__navNext);
				}
				
				for (x in tmp)
					if (tmp[x])
						tmp[x].addClass(settings.disabledNavClass).css('cursor', 'default');
			}

			function switchSlide(index)
			{
				var x;

				if (isLocked || currentIndex === index)
					return false;

				if (__jumpLinks)
					__jumpLinks.removeClass(settings.activeJumpLinkClass);

				if (settings.blurOnChange)
					jQuery('input, textarea, select').blur();
					
				isLocked = true;

				if (currentIndex === false)
				{
					currentIndex = index;
					__reel.css('left', -1 * list[currentIndex].x);
					isLocked = false;

					// Indicator
						if (__indicator)
						{
							__indicator.removeClass('active');
							jQuery(__indicator.get(currentIndex - pFirst)).addClass('active');
						}

					// Active slide
						if (settings.activeSlideClass)
							list[currentIndex].object
								.addClass(settings.activeSlideClass)

					// Link
						if (settings.clickToNav && !list[currentIndex].link)
							list[currentIndex].object
								.css('cursor', 'default');
					
					// Captions
						if (__captionLines)
						{
							if (list[currentIndex].captions)
								for (x in __captionLines)
									__captionLines[x].html(list[currentIndex].captions[x]);
							else
								for (x in __captionLines)
									__captionLines[x].html('');
						}

					// Nav controls
						updateNavControls();
						
					// Update jump link
						updateJumpLink(currentIndex);

					// Callback
						if (settings.onSlideSwitch)
						{
							window.setTimeout(function() {
								(settings.onSlideSwitch(list[currentIndex].object));
							}, 500);
						}
				}
				else
				{
					var diff, currentX, newX, realIndex;
					
					if (settings.activeSlideClass)
						list[currentIndex].object
							.removeClass(settings.activeSlideClass);

					if (settings.clickToNav)
						list[currentIndex].object
							.css('cursor', 'pointer');
					
					currentX = list[currentIndex].x;
					
					newX = list[index].x;
					diff = currentX - newX;

					// Get real index
						if (list[index].realIndex !== false)
							realIndex = list[index].realIndex;
						else
							realIndex = index;

					// Indicator
						if (__indicator)
						{
							__indicator.removeClass('active');
							jQuery(__indicator.get(realIndex - pFirst)).addClass('active');
						}

					// Captions
						if (__captionLines)
						{
							if (list[realIndex].captions)
								for (x in __captionLines)
									__captionLines[x].html(list[realIndex].captions[x]);
							else
								for (x in __captionLines)
									__captionLines[x].html('');
						}

					// Update jump link
						updateJumpLink(realIndex);

					// Transition
						switch (settings.mode)
						{
							case 'fadeIn':
								// Clone active slide
									x = list[currentIndex].object.clone();
									x
										.appendTo(__viewer)
										.css('left', 0)
										.css('top', 0);
								
								// Switch slide
									currentIndex = index;
									__reel.css('left', -1 * list[currentIndex].x);

								// Get real index and adjust reel position
									if (list[currentIndex].realIndex !== false)
									{
										currentIndex = list[currentIndex].realIndex;
										__reel.css('left', -1 * list[currentIndex].x);
									}

								// Active slide
									if (settings.activeSlideClass)
										list[currentIndex].object
											.addClass(settings.activeSlideClass);

								// Link
									if (settings.clickToNav && !list[currentIndex].link)
										list[currentIndex].object
											.css('cursor', 'default');

								// Nav controls
									updateNavControls();

								// Update URL
									updateURL();

								// Callback
									if (settings.onSlideSwitch)
										(settings.onSlideSwitch(list[currentIndex].object));
								
								// Fade out and remove itcloned slide
									x.fadeOut(settings.speed, function() {
										isLocked = false;
										x.remove();
									});
								
								break;

							case 'fade':
								__reel.fadeTo(settings.speed, 0.001, function() {
									currentIndex = index;
									__reel.css('left', -1 * list[currentIndex].x);

									// Get real index and adjust reel position
										if (list[currentIndex].realIndex !== false)
										{
											currentIndex = list[currentIndex].realIndex;
											__reel.css('left', -1 * list[currentIndex].x);
										}

									__reel.fadeTo(settings.speed, 1, function() {
										// Active slide
											if (settings.activeSlideClass)
												list[currentIndex].object
													.addClass(settings.activeSlideClass);

										// Link
											if (settings.clickToNav && !list[currentIndex].link)
												list[currentIndex].object
													.css('cursor', 'default');

										// Nav controls
											updateNavControls();

										// Update URL
											updateURL();

										// Callback
											if (settings.onSlideSwitch)
												(settings.onSlideSwitch(list[currentIndex].object));

										isLocked = false;
									});
								});
								break;
						
							case 'slide':
							default:
							
								__reel.animate({ left: '+=' + diff }, settings.speed, 'swing', function() {
									currentIndex = index;

									// Get real index and adjust reel position
										if (list[currentIndex].realIndex !== false)
										{
											currentIndex = list[currentIndex].realIndex;
											__reel.css('left', -1 * list[currentIndex].x);
										}

									// Active slide
										if (settings.activeSlideClass)
											list[currentIndex].object
												.addClass(settings.activeSlideClass);

									// Link
										if (settings.clickToNav && !list[currentIndex].link)
											list[currentIndex].object
												.css('cursor', 'default');

									// Nav controls
										updateNavControls();

									// Update URL
										updateURL();

									// Callback
										if (settings.onSlideSwitch)
											(settings.onSlideSwitch(list[currentIndex].object));

									isLocked = false;
								});
								
								break;
						}
				}
			}

			function initialize()
			{
				var tmp, a, s;

				list = new Array();

				// Slides, viewer, reel, indicator
					__viewer = getElement(settings.viewerSelector, true);
					__reel = getElement(settings.reelSelector, true);
					__slides = getElement(settings.slidesSelector, true);
					__indicator = getElement(settings.indicatorSelector, false);
					__jumpLinks = getElement(settings.jumpLinksSelector, false, true);

					if (settings.autoFit)
					{
						__viewer.height(Math.floor(__viewer.width() / settings.autoFitAspectRatio));

						__slides
							.width(__viewer.width())
							.height(__viewer.height());
					}

				// Caption lines
					a = new Array();
				
					for (i = 1; i <= settings.captionLines; i++)
					{
						s = settings.captionLineSelector;

						if (settings.captionLines > 1)
							s = s + i;

						tmp = getElement(s, false);
						
						if (tmp == null)
						{
							a = null;
							break;
						}
						
						a.push(tmp);
					}
					
					__captionLines = a;

				// Navigation
					__navFirst = getElement(settings.navFirstSelector);
					__navLast = getElement(settings.navLastSelector);
					__navNext = getElement(settings.navNextSelector);
					__navPrevious = getElement(settings.navPreviousSelector);
					__navStopAdvance = getElement(settings.navStopAdvanceSelector);
					__navPlayAdvance = getElement(settings.navPlayAdvanceSelector);

					if (__navFirst) __navControls.push(__navFirst);
					if (__navLast) __navControls.push(__navLast);
					if (__navNext) __navControls.push(__navNext);
					if (__navPrevious) __navControls.push(__navPrevious);

					if (settings.autoHideNav
					&&	__slides.length < 2)
					{
						for (x in __navControls)
							__navControls[x].remove();
					}
					
				// Check configuration status

					// ClickToNav only works when viewerOffset != false
						if (settings.viewerOffset === false
						&&	settings.clickToNav)
						{
							alert('Error: clickToNav only works when viewerOffset is in use.');
							return false;
						}

					// When using the indicator, it must have as many items as there are slides
						if (__indicator)
						{
							if (__indicator.length != __slides.length)
							{
								alert('Error: Indicator needs to have as many items as there are slides.');
								return false;
							}
						}
				
					// Final check
						if (isConfigured == false)
						{
							alert('Error: One or more configuration errors detected. Aborting.');
							return false;
						}

					if (settings.viewerOffset == false)
						settings.viewerOffset = 0;					

					if (settings.initialSlide == 'random')
						settings.initialSlide = Math.ceil(Math.random() * __slides.length);
					else if (isNaN(parseInt(settings.initialSlide)) == true || settings.initialSlide < 1 || settings.initialSlide > __slides.length)
						settings.initialSlide = 1;

				// Set up

					// Viewer
						__viewer.css('position', 'relative');
						__viewer.css('overflow', 'hidden');

					// Reel
						__reel.css('position', 'absolute');
						__reel.css('left', 0);
						__reel.css('top', 0);
						__reel.hide();

					// Slides
						var cx = 0, length = __slides.length;
				
						if (settings.seamlessWrap && settings.mode == 'slide')
						{
							isSeamless = true;

							var L1 = __slides.eq(0);
							var L2 = __slides.eq(Math.min(length - 1, 1));
							var R2 = __slides.eq(Math.max(length - 2, 0));
							var R1 = __slides.eq(Math.max(length - 1, 0));
							
							var realFirst = L1;
							var realLast = R1;

							var	CL1 = L1.clone(),
								CL2 = L2.clone(),
								CR1 = R1.clone(),
								CR2 = R2.clone();

							CL1.attr('id', '');
							CL2.attr('id', '');
							CR1.attr('id', '');
							CR2.attr('id', '');

							CR2.insertBefore(realFirst);
							CR1.insertBefore(realFirst);
							CL2.insertAfter(realLast);
							CL1.insertAfter(realLast);

							__slides = getElement(settings.slidesSelector, true);
							
							pFirst = 2;
							pLast = __slides.length - 3;
						}
						else
						{
							pFirst = 0;
							pLast = length - 1;
						}

						__slides.each(function(index) {

							var y = jQuery(this), link = false, captions = new Array();
							var l, i, tmp, s, id, p;

							// click to nav?
								if (settings.clickToNav)
								{
									y
										.css('cursor', 'pointer')
										.click(function(e) {
											if (currentIndex != index)
											{
												e.stopPropagation();

												if (isAdvancing)
													interruptAdvance();

												switchSlide(index);
											}
										});
								}

							// Link?
								var l = y.find(settings.slideLinkSelector);
								
								if (l.length > 0)
								{
									link = l.attr('href');
									l.remove();
									y
										.css('cursor', 'pointer')
										.click(function(e) {
											if (currentIndex == index)
												window.location = link;
										});
								}

							// Caption(s)?
								for (i = 1; i <= settings.captionLines; i++)
								{
									s = settings.slideCaptionSelector;

									if (settings.captionLines > 1)
										s = s + i;

									tmp = y.find(s);

									if (tmp.length > 0)
									{
										captions.push(tmp.html());
										tmp.remove();
									}
								}
							
								if (captions.length != settings.captionLines)
									captions = false;
							
							// id
								id = y.attr('id');
								
								if (!id)
									id = null;
									
								y.attr('id', '');
							
							list[index] = {
								object:		y,
								x:			cx - settings.viewerOffset,
								realIndex:	false,
								link:		link,
								captions:	captions,
								id:			id,
								jumpLink:	false
							};
							
							y.css('position', 'absolute');
							y.css('left', cx);
							y.css('top', 0);
							
							cx += y.width();
						});

						if (isSeamless)
						{
							list[pFirst - 1].realIndex = pLast;
							list[pLast + 1].realIndex = pFirst;
						}

					// Indicator
						if (__indicator)
						{
							__indicator.each(function() {
								var t = jQuery(this);
								
								t
									.css('cursor', 'pointer')
									.bind(_eventType, function(event) {
										event.preventDefault();

										if (isLocked)
											return false;

										if (isAdvancing)
											interruptAdvance();

										switchSlide(t.index() + pFirst);
									});

								if (_eventType != 'click')
									t.click(function(e) { e.preventDefault(); });
							});
						}

					// Jump links
						if (__jumpLinks)
						{
							__jumpLinks.each(function() {
								var i, t = jQuery(this), slideId = t.attr('href').split('#')[1];
								
								if ((i = getSlideById(slideId)) !== false)
								{
									list[i].jumpLink = t;
								
									t.click(function(e) {
										e.preventDefault();

										if (isAdvancing)
											interruptAdvance();

										switchSlide(i);
									});
								}
								else
									t.click(function(e) {
										e.preventDefault();
									});
							});
						}
					
					// Navigation
						if (__navFirst)
						{
							__navFirst.bind(_eventType, function(event) {
								event.preventDefault();

								if (isLocked)
									return false;

								if (isAdvancing)
									interruptAdvance();
								
								firstSlide();
							});

							if (_eventType != 'click')
								__navFirst.click(function(e) { e.preventDefault(); });
						}

						if (__navLast)
						{
							__navLast.bind(_eventType, function(event) {
								event.preventDefault();

								if (isLocked)
									return false;

								if (isAdvancing)
									interruptAdvance();

								lastSlide();
							});

							if (_eventType != 'click')
								__navLast.click(function(e) { e.preventDefault(); });
						}

						if (__navNext)
						{
							__navNext.bind(_eventType, function(event) {
								event.preventDefault();

								if (isLocked)
									return false;

								if (isAdvancing)
									interruptAdvance();

								nextSlide();
							});

							if (_eventType != 'click')
								__navNext.click(function(e) { e.preventDefault(); });
						}

						if (__navPrevious)
						{
							__navPrevious.bind(_eventType, function(event) {
								event.preventDefault();

								if (isLocked)
									return false;
							
								if (isAdvancing)
									interruptAdvance();

								previousSlide();
							});

							if (_eventType != 'click')
								__navPrevious.click(function(e) { e.preventDefault(); });
						}

						if (__navStopAdvance)
						{
							__navStopAdvance.bind(_eventType, function(event) {
								event.preventDefault();

								if (isLocked)
									return false;

								if (!isAdvancing)
									return false;

								stopAdvance();
							});

							if (_eventType != 'click')
								__navStopAdvance.click(function(e) { e.preventDefault(); });
						}

						if (__navPlayAdvance)
						{
							__navPlayAdvance.bind(_eventType, function(event) {
								event.preventDefault();

								if (isLocked)
									return false;

								if (isAdvancing)
									return false;

								playAdvance();
							});

							if (_eventType != 'click')
								__navPlayAdvance.click(function(e) { e.preventDefault(); });
						}

					// Arrow navigation

						if (settings.arrowsToNav)
						{
							jQuery(document).keydown(function(e) {
								switch (e.keyCode)
								{
									case 37:
										if (isLocked)
											return false;

										if (isAdvancing)
											interruptAdvance();
	
										previousSlide();
										
										break;
										
									case 39:
										if (isLocked)
											return false;

										if (isAdvancing)
											interruptAdvance();

										nextSlide();
										
										break;
									
									default:
										break;
								}
							});
						}

					__reel.fadeIn(settings.fadeInSpeed);
					
				return true;
			}

			// Bind events
				var o = (settings.selectorParent ? settings.selectorParent : settings.viewerSelector);
				
				if (o)
				{
					o
						.bind('previousSlide', function() { if (isAdvancing) interruptAdvance(); previousSlide(); })
						.bind('nextSlide', function() { if (isAdvancing) interruptAdvance(); nextSlide(); })
						.bind('firstSlide', function() { if (isAdvancing) interruptAdvance(); firstSlide(); })
						.bind('lastSlide', function() { if (isAdvancing) interruptAdvance(); lastSlide(); })
						.bind('slidertron_onSwitchSlide', function() {
						})
						.bind('slidertron_reFit', function() {
							var cx = 0;

							if (isAdvancing)
								interruptAdvance();

							window.setTimeout(function() {
								for (x in list)
								{
									list[x].object.width(__viewer.width());
									list[x].x = cx - settings.viewerOffset;
									list[x].object.css('left', cx);
									cx += list[x].object.width();
								}
								__reel.css('left', -1 * list[currentIndex].x);
								__viewer.height(Math.floor(__viewer.width() / settings.autoFitAspectRatio));
							}, 100);
						})
						.bind('slidertron_stopAdvance', function() {
							if (isAdvancing)
								stopAdvance();
						});
				}

			// Ready
				jQuery().ready(function() {
					var id = window.location.hash.split('#')[1], x, y = true;
					if (id)
						window.location.hash = '';

					if (initialize())
					{
						if (settings.hashJump && id && (x = getSlideById(id)) !== false)
						{
							setTimeout(function() { window.scrollTo(0,0); }, 0);
							switchSlide(x);
							if (x != pFirst)
								window.location.hash = '#' + id;
							if (settings.hashJumpStopAdvance)
								y = false;
						}
						else
						{
							if (settings.seamlessWrap)
								switchSlide(settings.initialSlide + 1);
							else
								switchSlide(settings.initialSlide - 1);
						}

						if (y)
							timeoutID = window.setTimeout(function() {
								initializeAdvance();
							}, settings.advanceWait);
					}
				});
	};

})(jQuery);