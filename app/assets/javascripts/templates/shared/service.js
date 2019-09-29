(function() {
    var App;
    App = window.App = {};

    App.srv = {
        render: function(template, args) {
            return JST["templates/" + template](args);
        }
    };
}).call(this);
