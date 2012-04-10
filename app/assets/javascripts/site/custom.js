$(document).ready(function() {


    $("ul.lavaLamp").lavaLamp({fx: "easeOutBack", speed: 700});

    $("a.link").mouseover(function() {
            $(this).animate({
               paddingRight: "+=7px"
            }, 250);
        }).mouseout(function() {
                $(this).animate({
                    paddingRight: "-=7px"
                },250);
        });


    $("div.tag-toggle-btn").click(function() {
        $("div.tag-cloud").slideToggle(300)
    })
});