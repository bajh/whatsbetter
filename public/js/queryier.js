$( document ).ready(function() {
  
 
  $(window).keydown(function(e){
    var againStyle = $('.again-btn').attr('style');
    if (againStyle != "display: none;" && e.which == 13 ){
      $('.again-btn').click();
    }
  });

  // AJAX STUFF
  // var $term1 = $('.term1'),
  //     $term2 = $('.term2');


  $('.query-form').submit(function(e){
    e.preventDefault();
 
    if ($('.term1').val() == ''){
      var $term1 = $('.term1').attr('placeholder'),
    } else {
      var $term1 = $('.term1').val(),
    }

    if ($('.term2').val() == ''){
      var $term2 = $('.term2').attr('placeholder'),
    } else {
      var $term2 = $('.term2').val(),
    }

    $.ajax({
      type: "GET",
      url: "/query",
      data: {term1: $term1, term2: $term2},
      success: function(response){
        viewResults(response);
        fillContent(response);
        
      }
    });
  });

  // JQUERY ANIMATIONS

  var $vs = $('.vs'),
      $textBox = $('.text-box'),
      $resultsBtn = $('.results-btn'),
      $againBtn = $('.again-btn'),
      $vsMobile = $('.input-spacer'),
      $contentTitle = $('.content-title');

  $contentTitle.hide();
  $vs.hide();
  $vsMobile.hide();
  $textBox.hide();
  $againBtn.hide();
  $resultsBtn.hide();

  // intro animations
  $vs.fadeIn("slow", function(){
    $vsMobile.fadeIn(100);
    $textBox.first().slideDown("slow"); 
    $textBox.last().slideDown("slow", function(){
      $resultsBtn.fadeIn(300);
    });
  });

  function viewResults(){
    $term1.fadeOut();
    $term2.fadeOut(function(){
      $('.box-wrapper').animate({padding: '0'});
      if ($(window).width() > 480) {
        $('.btn-wrapper').animate({'marginTop': '+=145px'});
        $('.footer').animate({'marginTop': '+=145px'});
      }else{
        $('.btn-wrapper').animate({'marginTop': '+=580px'});
        $('.footer').animate({'marginTop': '+=580px'});
      };
      $resultsBtn.fadeOut(function(){
          $againBtn.fadeIn();
        });
      $textBox.animate({
        height: '385px'
      }, function(){
        appendDivs();
      });
    });
  }

  function fillContent(response){
    var $firstDiv = $contentTitle.first(),
        $lastDiv = $contentTitle.last();

    if (response.winner.div_id === 1) {
      var term1_obj = response.winner;
      var term2_obj = response.loser;
      $firstDiv.find('.stats').addClass('stats-winner');
      $lastDiv.find('.stats').addClass('stats-loser');
    }else{
      var term1_obj = response.loser;
      var term2_obj = response.winner;
      $firstDiv.find('.stats').addClass('stats-loser');
      $lastDiv.find('.stats').addClass('stats-winner');
    };

    $firstDiv.find('h2').text(term1_obj.content);
    $lastDiv.find('h2').text(term2_obj.content);
    $firstDiv.find('h3').text(term1_obj.num);
    $lastDiv.last().find('h3').text(term2_obj.num);
    $firstDiv.find('h4').text(term1_obj.unit);
    $lastDiv.last().find('h4').text(term2_obj.unit);
  }

  function appendDivs(){
    $contentTitle.fadeIn();
  }

});