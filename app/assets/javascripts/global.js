// (Start) Date & Datetime Pickers.
    $('.datepicker, input[type="date"]:not([data-vv-as])').attr('placeholder', 'dd/mm/yyyy');

    var datepickerDefault = function() {
        return {
            disableMobile: 'true',
            dateFormat: 'Y-m-d',
            altInput: true,
            altFormat: 'd/m/Y',
            minDate: '1950',
            allowInput: true,
            onClose(dates, currentdatestring, picker) {
                picker.setDate(picker.altInput.value, true, picker.config.altFormat)
            }
        };
    }

    var datetimepickerDefault = function() {
        return {
            disableMobile: 'true',
            enableTime: true,
            dateFormat: 'Y-m-d H:i',
            altInput: true,
            altFormat: 'd/m/Y G:i:S K',
            minDate: '1950',
            allowInput: true

            // TAB OnClose does not seem to work for datetimepicker.
            // onClose(dates, currentdatestring, picker) {
            //     picker.setDate(picker.altInput.value, true, picker.config.altFormat)
            // }
        };
    }

    var monthpickerDefault = function() {
        return {
            disableMobile: 'true',
            altInput: true,
            minDate: '1950',
            allowInput: true,
            plugins: [new monthSelectPlugin({shorthand: false, dateFormat: "Y-m-d", altFormat: "M Y"})],
            onClose(dates, currentdatestring, picker) {
                picker.setDate(picker.altInput.value, true, picker.config.altFormat)
            }
        };
    }

    // Flatpickr for Dates.
    $('.datepicker:not([readonly]), input[type="date"]:not([data-vv-as]):not([readonly])').each(function() {
        if ($(this).attr('min')) {
            $(this).attr('data-start-date', $(this).attr('min'));
            $(this).removeAttr('min');
        }

        if ($(this).attr('max')) {
            $(this).attr('data-end-date', $(this).attr('max'));
            $(this).removeAttr('max');
        }

        var startDate   = $(this).attr('data-start-date');
        var endDate     = $(this).attr('data-end-date');
        var options     = datepickerDefault();
        if (startDate)  options.minDate = startDate;
        if (endDate)    options.maxDate = endDate;
        insertFlatpickrParsley(this);
        $(this).flatpickr(options);
    });

    // Filter Dropdown Datepicker Range fields, to update corresponding values. Does not support input[type="date"] because datepicker will change the original input to input[type="hidden"]
    $('.datepicker.datepicker-range-filter:not([readonly])').change(function() {
        var type        = $(this).attr('data-type');
        var target      = $(this).attr('data-target');
        var dateValue   = $(this).val();
        var otherType   = type === 'start' ? 'end' : 'start';
        var checkDate   = dateValue ? dateValue : null;
        var options     = datepickerDefault();
        var otherField  = $(`.datepicker.datepicker-range-filter[data-type="${ otherType }"][data-target="${ target }"]`);
        options.defaultDate = otherField.val();
        originalMaxDate = $(otherField).attr('data-end-date');
        originalMinDate = $(otherField).attr('data-start-date');

        if (type === 'start' && originalMinDate && checkDate) {
            options.minDate = originalMinDate > checkDate ? originalMinDate : checkDate;
        } else if (originalMinDate) {
            options.minDate = originalMinDate;
        } else if (type === 'start') {
            options.minDate = checkDate;
        }

        if (type === 'end' && originalMaxDate && checkDate) {
            options.maxDate = originalMaxDate < checkDate ? originalMaxDate : checkDate;
        } else if (originalMaxDate) {
            options.maxDate = originalMaxDate;
        } else if (type === 'end') {
            options.maxDate = checkDate;
        }

        $(otherField).flatpickr(options);
    });

    // Flatpickr for DateTime.
    $('.datetimepicker:not([readonly])').each(function() {
        if ($(this).attr('min')) {
            $(this).attr('data-start-date', $(this).attr('min'));
            $(this).removeAttr('min');
        }

        if ($(this).attr('max')) {
            $(this).attr('data-end-date', $(this).attr('max'));
            $(this).removeAttr('max');
        }

        var startDate   = $(this).attr('data-start-date');
        var endDate     = $(this).attr('data-end-date');
        var options     = datetimepickerDefault();
        if (startDate)  options.minDate = startDate;
        if (endDate)    options.maxDate = endDate;
        insertFlatpickrParsley(this);
        $(this).flatpickr(options);
    });

    // Flatpickr for Dates.
    $('.datepicker-month').each(function() {
        var options = monthpickerDefault();
        $(this).flatpickr(options);
    });

// (End)

function insertFlatpickrParsley(field) {
    // Insert a error container div for parsley after this field. The div needs to be hidden because on submission, the required tag on the parsley altInput will cause two error messages to show up. This div is used only to prevent the error showing up above the altInput field.
    var parsleyContainerId  = `flatpickr-parsley-error-container-${ $(field).attr('name').replace(/\[|\]/g, '_') }`;
    $(`<div id="${ parsleyContainerId }" class="hidden"></div>`).insertAfter(field);
    $(field).attr('data-parsley-errors-container', `#${ parsleyContainerId }`);
}

// Prevents forms from being submitted on "ENTER" keypress, except on textarea.
$('form.disable-enter-keypress').on('keypress', function (e) {
    if (e.keyCode === 13 && !$(e.target).is('textarea')) {
        return false;
    }
});

// Toggles disabled attribute to fields. Will set to disabled if boolean is true, and remove if false.
function toggleDisabledAttr(element, boolean) {
    boolean ? element.attr('disabled', 'true') : element.removeAttr('disabled');
}

// Scrolls to the element, while trying to center it to the screen.
function scrollToElement(element, speed, extra_offset = 0) {
    $('body, html, .modal').animate({
        // Offset 100 for navbar and some space at the top
        scrollTop: element.offset().top - 300 - extra_offset
    }, speed);
}

// Opens a dialog box (modal) and prevents form submissions.
function openDialogAndPreventSubmit(selector, e, type = 'warning') {
    openDialog({target: selector, type: type})
    e.preventDefault();

    // Need to delay the action to ensure it always works.
    setTimeout(function() {
        $('input[type="submit"]').removeAttr('disabled');
    }, 200)
}

// Opens a dialog box, must supply target and type.
function openDialog(options) {
    $(options.target).dialog({
        modal: true,
        minWidth: 600,
        dialogClass: `dialog__title-${options.type} shadow`,
        buttons: {
            Close: function() {
               $(this).dialog('close');
            }
        }
    });
}
// Opens a dialog box for email reminder
function openDialog_logout(options) {
    $(options.target).dialog({
        modal: true,
        minWidth: 600,
        dialogClass: `dialog__title-${options.type} shadow`,
        closeOnEscape: false,
        // buttons: {
        //     Close: function() {
        //        $(this).dialog('close');
        //     }
        // }
        open: function(event, ui) { $(".ui-dialog-titlebar-close").hide(); }
    });
}
// Dropdown toggle bar with persistent state using cookies.
$('.dropdown-toggle-bar').click(function() {
    var target      = $(this).attr('data-target');
    var display     = $(`.dropdown-toggle-display[data-target="${ target }"]`);
    var chevron     = $(this).find('i.fas');
    var newState    = chevron.hasClass('fa-chevron-down') ? 'left' : 'down';
    Cookies.set(`dropdown_toggle_${ target }`, newState);
    chevron.toggleClass('fa-chevron-down fa-chevron-left');
    display.toggle();
});

// Summernote is not included in every page.
if ($('.wysiwyg').length > 0) {
    $('.wysiwyg').summernote({
        height: 300
    });
}

$('form.with-parsley').parsley({
    errorClass: 'is-invalid text-danger border-danger',
    errorsWrapper: '<div class="invalid-feedback d-block"></div>',
    errorTemplate: '<span></span>',
    trigger: 'change',
    excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
});

$('.select2').on('change.select2', function(e) {
    var form    = $(this).closest('form');
    var id      = $(this).attr('data-parsley-group');

    if (form.length > 0 && form.hasClass('with-parsley') && id) {
        $(form).parsley().validate(id);
    }
});

// Will need to customize how .active class is set.
// For some reason, core UI has it's own javascript which is causing bugs for Transactions Index.
var activeLinkChecks    = $('.custom-active-link');
var currentPath         = window.location.pathname;
var parameters          = window.location.href.split('?')[1];
var splitParams         = parameters ? parameters.split('&') : '';

// CoreUI will cause a bug it will always run, so need it to run first then only run this method. Need to settimeout. Let it run for 10 seconds.
for (i = 0; i < 10000; i+=50) {
    setTimeout(assignActiveLinks, i);
}

function assignActiveLinks() {
    activeLinkChecks.each(function() {
        var path    = $(this).attr('data-path');
        var params  = $(this).attr('data-params').split('&');

        sameParams = !$(params).map(function() {
            return splitParams.includes(this.toString());
        }).get().includes(false);

        if (currentPath === path && sameParams) {
            $(this).addClass('active');
        } else {
            $(this).removeClass('active');
        }
    });
}

$('.navbar-toggler.sidebar-toggler[data-toggle="sidebar-lg-show"]').click(function() {
    state = !$('body').hasClass('sidebar-lg-show');
    Cookies.set(`sidebar_lg_state`, state);
});

$('.dropdown-filter-form-holder input[type="text"]').change(function() {
    $(this).val($(this).val().trim());
});