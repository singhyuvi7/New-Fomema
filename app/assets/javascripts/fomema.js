// console.log('javascript/fomema.js loaded');

$(document).ready(function () {
    $('[data-toggle="tooltip"]').tooltip();
    $('[data-toggle="popover"]').popover();

    $('input[type=email]:not(.no-uppercase)').change(function () {
        this.value = this.value.toUpperCase();
    });

    $('input[type=text]:not(.no-uppercase)').change(function () {
        this.value = this.value.toUpperCase();
    });

    $('textarea:not(.no-uppercase)').change(function () {
        this.value = this.value.toUpperCase();
    });

    $('.master-checkbox').change(function() {
        var target = $(this).attr('data-target') ? "."+$(this).attr('data-target') : '.child-checkbox';
        $(target).prop('checked', $(this).prop('checked'));
    });

    $('.bulk-toggle').change(function() {
        var target = $(this).attr('data-target') ? $(this).attr('data-target') : '.child-checkbox';
        $(target).prop('checked', $(this).prop('checked'));
    });

    // Enable option for select2 to only match from start of the term.
    function matchStart(params, data) {
        params.term = params.term || '';

        if (data.text.toUpperCase().indexOf(params.term.toUpperCase()) == 0) {
            return data;
        }

        return false;
    }

    setTimeout(function () {
        $('.select2').each(function () {
            option = {
                theme: 'bootstrap',
                matcher: function(params, data) {
                    return matchStart(params, data);
                }
            }
            if (this.getAttribute('dropdownparent')) {
                option.dropdownParent = $(this.getAttribute('dropdownparent'))
            }
            $(this).select2(option);
        });
    }, 100);
});

function randomString(length, charset)
{
    if (length === undefined) {
        length = 10;
    }
    if (charset === undefined) {
        charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    }
    var ret = "";
    for (var i = 0; i < length; ++i) {
        ret += charset.charAt(Math.floor(Math.random() * charset.length));
    }
    return ret;
}

// The minimum is inclusive and the maximum is inclusive
function randomInteger(min, max)
{
    if (min === undefined) {
        min = 0;
    }
    if (max === undefined) {
        max = 9;
    }
    if (max < min) {
        var max2 = min;
        min = max;
        max = max2;
    }
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function shuffle(str)
{
    var strs = str.split('');
    var ret = '';
    while (strs.length > 0) {
        ret += strs.splice(randomInteger(0, strs.length-1), 1);
    }
    return ret;
}