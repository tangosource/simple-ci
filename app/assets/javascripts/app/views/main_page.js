simpleCI.Views.mainPage = Backbone.View.extend ({
  el: 'body',

  events: {
    'change .github_url' : 'validateUrl'
  },

  initialize: function(){
  },

  validateUrl: function(e){
      var regex = new RegExp("(https://github.com)+(\/[a-zA-Z0-9\-_]+)+(\/[a-zA-Z0-9\-_]+)+$");
        if(regex.test(e.target.value)){
          $header = this.$el.find('header');
          scriptTemplate = _.template(JST['templates/script_template']());

          console.log("Successful match");

          $header.addClass('red');
          $header.find('input').replaceWith(scriptTemplate);

          this.scriptArea = new simpleCI.Views.scriptStage();
          this.scriptArea.fetchScript(e.target.value)

          setTimeout(function(){
            $header.find('div.form-control').addClass('script-stage');
          }, 0);

          $header.find('p').slideUp('slow').remove();
         $('.text-url-github, .text-worker').hide('fast');
      }else{
          console.log("No match");
      }
  }
})
