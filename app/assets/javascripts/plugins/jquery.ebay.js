/*!
 * jQuery Ebay Plugin
 *
 * Turns a form into an ebay api
 */

(function (factory) {
  if (typeof define === 'function' && define.amd) {
    // AMD. Register as anonymous module.
    define(['jquery'], factory);
  } else {
    // Browser globals.
    factory(jQuery);
  }
}(function ($) {
  var config = {
    baseUrl: "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=SeanSehr-1b80-440f-a5ae-43ff8c0e775a&GLOBAL-ID=EBAY-US&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&paginationInput.entriesPerPage=16&outputSelector(0)=PictureURLLarge",
    container: window,
    gridContainer: 'ul.search-grid'
  },
  gridContainer,
  inputs = {},
  page = 1;

  config.inputs = {
    'query': '#query',
    'price': '#price',
    'endTime': '#end-time',
    'endUnit': '#end-unit',
    'sort': '#sort'
  };
  config.map = {
    'query': 'keywords',
    'price': {
      'name': 'MaxPrice',
      'paramName': 'Currency',
      'paramValue': 'USD'
    },
    'endTime': {
      'name': 'EndTimeTo'
    },
    'sort': 'sortOrder'
  };

  var values = {
    'query': false,
    'price': false,
    'endTime': false
  };

  function addItem(item) {
    template(item).appendTo(gridContainer);
  }

  function addItems(items, removeCurrentItems) {
    if (removeCurrentItems) {
      gridContainer.empty();
    }
    $(items).each(function () {
      addItem(this);
    });
  }

  function buildQuery() {
    var url = config.baseUrl,
    i = 0;

    for (var index in values) {
      var value = values[index];
      if (value) {
        if (typeof config.map[index] === 'object') {
          for (var mapIndex in config.map[index]) {
            var mapValue = config.map[index][mapIndex];
            url += '&itemFilter(' + i + ').' + mapIndex + '=' + mapValue ;
          }
          url += '&itemFilter(' + i + ').value=' + value;
          i++;
        }
        else {
          url += '&' + config.map[index] + '=' + value;
        }
      }
    }

    return url;
  }

  function calcTimeUTC(amount, unit) {
    var time = new Date();
    switch(unit) {
      case 'minutes':
        time.addMinutes(amount);
        break;
      case 'hours':
        time.addHours(amount);
        break;
      case 'days':
        time.addDays(amount);
        break;
    }
    return time.toISOString();
  }

  function calcTimeLeft(timeString) {
    var time = new Date(timeString);
    //time = time.toString('M/d/yyyy');
    var timetill = (time - new Date()) / 1000,
        unit = 'minutes';

    timetill = timetill / 60;
    if (timetill > 60) {
      timetill = timetill / 60;
      unit = 'hours';
      if (timetill > 24) {
        timetill = timetill / 24;
        unit = 'days';
      }
    }

    return Math.round(timetill) + ' ' + unit + ' left';
  }

  function getElements() {
    gridContainer = $(config.gridContainer);
    for (var index in config.inputs) {
      var value = config.inputs[index];
      inputs[index] = $(value, config.container);
    }
  }

  function loadMore() {
    var url = buildQuery();
    page++;
    url += '&callback=ebayAddCB&paginationInput.pageNumber=' + page;
    search(url);
  }

  function refreshValues() {
    for (var index in inputs) {
      var value = inputs[index];
      var val = value.val();
      if (typeof val !== 'undefined') {
        if (index === 'endTime') {
          if (val) {
            var amount = val,
                unit = inputs.endUnit.val();
            values[index] = calcTimeUTC(amount, unit);
          }
          else {
            values[index] = '';
          }
        }
        else if (index !== 'endUnit') {
          values[index] = val;
        }
      }
    }
  }

  function search(url) {
    // remove old script
    $('script[data-ebay]').remove();

    s = document.createElement('script'); // create script element
    s.src = url;
    s.setAttribute('data-ebay', true);
    document.body.appendChild(s);
  }

  function template(item) {
    var container = $('<li/>', {
      'class': 'grid-item',
    }),
    timeLeft = calcTimeLeft(item.listingInfo[0].endTime[0]);

    $('<div/>', {
      'class': 'thumbnail-wrapper',
      'html': $('<a/>', {
        'target': '_blank',
        'href': item.viewItemURL[0],
        'html': $('<img/>', {
          'class': 'thumbnail',
          'src': item.pictureURLLarge ? item.pictureURLLarge[0] : item.galleryURL[0]
        })
      })
    }).appendTo(container);
    $('<div/>', {
      'class': timeLeft.indexOf('minutes') != -1 ? 'item-time ending-soon' : 'item-time',
      'text': timeLeft
    }).appendTo(container);
    $('<div/>', {
      'class': 'item-price',
      'text': item.sellingStatus[0].convertedCurrentPrice[0]['__value__'].formatMoney()
    }).appendTo(container);
    $('<h5/>', {
      'class': 'item-title',
      'html': $('<a/>', {
        'target': '_blank',
        'href': item.viewItemURL[0],
        'text': item.title[0]
      })
    }).appendTo(container);
    return container;
  }

  function throwError(errorMessage) {
    gridContainer.empty();
    $('<li/>', {
      html: $('<div/>', {
        class: 'alert-box alert',
        text: errorMessage
      })
    }).appendTo(gridContainer);
  }

  function trigger() {
    refreshValues();
    valdation();

    page = 1;
    var url = buildQuery() + '&callback=ebayNewSearchCB';
    search(url);
  }

  function valdation(callback) {
    if (!values.query) {
      throwError('Search Term Required');
      return false;
    }
  }

  function init() {
    getElements();
    for (var index in inputs) {
      var value = inputs[index];
      if (value.is('input')) {
        value.donetyping(trigger);
      }
      else if (value.is('select')) {
        value.change(trigger);
      }
    }
    $(document).on('click', '#load-more', function(e) {
      loadMore();
      e.preventDefault();
    });

    trigger();
  }

  function ebayCallback(root, removeCurrentItems) {
    if (root.findItemsByKeywordsResponse[0].ack[0] === 'Success') {
      var items = root.findItemsByKeywordsResponse[0].searchResult[0].item || [];
      // TO DO: check if there are no items
      if (items.length < 1) {
        throwError(values.query + ' returned no results');
      }
      else {
        addItems(items, removeCurrentItems);
      }
    }
  }

  window.ebayAddCB = function(root) {
    ebayCallback(root, false);
  };

  window.ebayNewSearchCB = function(root) {
    ebayCallback(root, true);
  };

  $.fn.ebayapi = function (options) {
    return this.each(function() {
      config.container = this;
      $.extend(config, options);
      init();
    });
  };

}));