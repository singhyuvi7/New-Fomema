function initializeToggleableFields(pageType) {
    $('.toggle-boolean-field-btn').click(function() {
        disabledField   = $(this).closest('.boolean-field-parent').hasClass('bg-secondary');
        if (disabledField) { return false; }
        type            = $(this).attr('data-type');
        parent          = $(this).closest('.boolean-field-parent');
        toggleBooleanFields(this, type, parent);

        if (pageType === 'doctor examination') {
            doctorExamSpecificFunctions(this, type, parent);
        } else if (pageType === 'xray examination') {
            xrayExamSpecificFunctions(this, type, parent);
        } else if (pageType === 'laboratory examination') {
            laboratoryExamSpecificFunctions(this, type, parent);
        }
    });
    toggleDisabledAttr($('#de_attributes_physical_vision_test_aided_left_a_value'), false);
    toggleDisabledAttr($('#de_attributes_physical_vision_test_aided_left_b_value'), false);
    toggleDisabledAttr($('#de_attributes_physical_vision_test_aided_right_a_value'), false);
    toggleDisabledAttr($('#de_attributes_physical_vision_test_aided_right_b_value'), false);
}

function doctorExamSpecificFunctions(button, type, parent) {
    dateField = parent.find('.date-field-check');
    toggleDisabledAttr(dateField, type === 'false');

    numberFields = $('.number-input-bool-field');
    numberFields.each(function() {
        normal = $(this).closest('.boolean-field-parent').find('.boolean-field').val() !== 'true';
        toggleDisabledAttr($(this).closest('.vision_parent').find('.number-input-field'), normal);
    });
    toggleDisabledAttr($('#de_attributes_physical_vision_test_aided_left_a_value'), false);
    toggleDisabledAttr($('#de_attributes_physical_vision_test_aided_left_b_value'), false);
    toggleDisabledAttr($('#de_attributes_physical_vision_test_aided_right_a_value'), false);
    toggleDisabledAttr($('#de_attributes_physical_vision_test_aided_right_b_value'), false);
}

function xrayExamSpecificFunctions(button, type, parent) {
    commentField            = parent.find('.comment-field');
    toggleDisabledAttr(commentField, type !== 'true');
    reporterField           = $('#transaction_xray_reporter_type');
    selectRadiologist       = $('#transaction_radiologist_id');
    toggleDisabledAttr(selectRadiologist, reporterField.val() === 'SELF');
    examDone                = $('#xe_attributes_xray_examination_not_done').val() === 'NO';
    reportFields            = $('#report-fields .boolean-field-parent:not(.except-this)');
    commentFields           = $('.comment-field');
    impressionDateFields    = $('.exam-done-toggle');
    toggleDisabledAttr(impressionDateFields, !examDone);

    if (examDone) {
        reportFields.removeClass('bg-secondary');

        commentFields.each(function() {
            normal = $(this).closest('.boolean-field-parent').find('.boolean-field').val() !== 'true';
            toggleDisabledAttr($(this), normal);
        });
    } else {
        reportFields.addClass('bg-secondary');
        toggleDisabledAttr(commentFields, true);
    }
}

function laboratoryExamSpecificFunctions(button, type, parent) {
    examDone                = $('#le_attributes_laboratory_test_not_done').val() === 'NO';
    reportFields            = $('#report-fields .boolean-field-parent:not(.except-this)');
    numberFields            = $('.number-input-bool-field');
    reasonDateFields        = $('.exam-done-toggle');
    toggleDisabledAttr(reasonDateFields, !examDone);
    bloodGroup              = $('#le_attributes_blood_group').val() === 'OTHER';
    bloodOther              = $('#le_attributes_blood_group_other');
    bloodRhesus             = $('#le_attributes_blood_group_rhesus').val() === 'OTHER';
    bloodRhesusOther        = $('#le_attributes_blood_group_rhesus_other');
    toggleDisabledAttr(bloodOther, !examDone || !bloodGroup);
    toggleDisabledAttr(bloodRhesusOther, !examDone || !bloodRhesus);

    if (examDone) {
        reportFields.removeClass('bg-secondary');

        numberFields.each(function() {
            normal  = $(this).closest('.boolean-field-parent').find('.boolean-field').val() !== 'true';
            toggleDisabledAttr($(this).closest('.sugar_albumin_parent').find('.number-input-field'), normal);
        });
    } else {
        reportFields.addClass('bg-secondary');
        toggleDisabledAttr($('.number-input-field'), true);
    }
}

function toggleBooleanFields(element, type, parent) {
    button      = $(element);
    addClass    = button.attr('data-active');
    parent.find('.toggle-boolean-field-btn').removeClass('btn-success btn-danger btn-primary').addClass('btn-default');
    inputField  = parent.find('.boolean-field');
    inputField.val(type);
    inputField.trigger('change');
    button.addClass(addClass);
}

function loadParentCategoryTabSelection() {
    $('.category-parent-tab').click(function() {
        type = $(this).attr('data-type');
        $('.category-parent-tab, .category-tab').removeClass('btn-primary').addClass('btn-default');
        $('.category-tab').addClass('hidden').removeClass('btn');
        childrenTabs = $(`.category-tab[data-parent="${type}"]`);
        childrenTabs.removeClass('hidden').addClass('btn');
        firstTab = $(childrenTabs[0]);
        $(this).removeClass('btn-default').addClass('btn-primary');
        $('input#p_tab').val(type);
        firstTab.click();
    });
}

function loadCategoryTabSelection() {
    $('.category-tab').click(function() {
        type    = $(this).attr('data-type');
        $('.category-switchable').addClass('hidden');
        $(`.category-switchable[data-type="${type}"]`).removeClass('hidden');
        $('.category-tab').removeClass('btn-primary').addClass('btn-default');
        $(this).removeClass('btn-default').addClass('btn-primary');
        $('input#tab').val(type);
    });
}

function highlightElement(element, color, speed) {
    element.animate({backgroundColor: color}, speed);
}

function delayedHighlightField(element, color, speed, delay) {
    setTimeout(function() {
        element.animate({backgroundColor: color}, speed);
    }, delay);
}

$(document).ready(function() {
    $('.measurement-range-check').change(function(e) {
        type    = $(this).attr('data-type');
        value   = $(this).val();

        if (!value.trim()) {
            return false;
        }

        focusField      = $(this).closest('.boolean-field-parent');
        floatedValue    = parseFloat(value);

        parameters = {
            physical_height: {name: 'HEIGHT', min: 75, max: 225},
            physical_weight: {name: 'WEIGHT', min: 30, max: 120},
            physical_pulse: {name: 'PULSE', min: 40, max: 120},
            physical_blood_pressure_systolic: {name: 'SYSTOLIC', min: 80, max: 139},
            physical_blood_pressure_diastolic: {name: 'DIASTOLIC', min: 50, max: 89}
        }[type]

        if (floatedValue < parameters.min || parameters.max < floatedValue) {
            $('#dialog-measurement-range-transmit label').text(parameters.name);
            $('#dialog-measurement-range-transmit span').text(`${parameters.min} - ${parameters.max}`);
            openDialogAndPreventSubmit('#dialog-measurement-range-transmit', e);

            $('#dialog-measurement-range-transmit').on('dialogclose', function(event, ui) {
                scrollToElement(focusField, 500);
                highlightElement(focusField.closest('.boolean-field-parent'), '#facf7f', 'slow');
                delayedHighlightField(focusField.closest('.boolean-field-parent'), '#fff', 'slow', 5000);
            });
        }
    });
});

$('.primary-selection.toggle-boolean-field-btn').click(function() {
    positive    = $(this).attr('data-type') === 'true';
    primaryName = $(this).attr('data-name');
    secondary   = $(`.secondary-selection[data-name="${primaryName}"]`);

    secondary.each(function() {
        disabledType = $(this).attr('data-type') === 'NA';

        // Please note this is an XNOR operator.
        if (positive === disabledType) {
            $(this).addClass('hidden');
        } else {
            $(this).removeClass('hidden');
        }
    });
});

$('.appeal-button').click(function(e) {
    e.preventDefault();
    var dialogBox   = $('#dialog-appeal');
    var list        = $(this).attr('data-list');
    var name        = $(this).attr('data-name');
    var url         = $(this).attr('data-path');
    var type        = $(this).attr('data-type');
    var ongoing     = $(this).attr('data-ongoing');
    var transId     = $(this).attr('data-transaction-id');
    var pdpaForm    = $(this).attr('data-pdpa-path');
    var title       = `Appeal for ${name}`;
    var parsedList  = JSON.parse(list);
    dialogBox.empty();

    if (parsedList.length > 0) {
        var listItems   = $(parsedList).map(function() {
            return `<li>${ this }</li>`
        }).get().join('');

        var ineligible      = `<p>Foreign worker ${ name } is ineligible for an appeal due to the following reason(s):</p><ol>${ listItems }</ol>`;
        var dialogButtons   = {
            Close: function() {
                $(this).dialog('close');
            }
        }

        if (ongoing === 'true') {
            ineligible          = `${ ineligible }<p class="mb-0">There is an ongoing appeal for this transaction. Unable to start a new appeal.</p>`;
        } else if (type === 'pic') {
            ineligible          = `${ ineligible }<p class="mb-0">You may still review exam results and initialize an appeal for this foreign worker.</p>`;
            dialogButtons.Begin = function() {
                window.location = url;
            }
        }

        dialogBox.append(ineligible);

        $('#dialog-appeal').dialog({
            title: title,
            modal: true,
            minWidth: 600,
            dialogClass: `dialog__title-danger shadow`,
            buttons: dialogButtons
        });
    } else {
        if (type == 'employer') {
            dialogBox.append(`<p><input type="checkbox" id="chkAgree"/> By initiating appeal, I, the employer of ${name}, agree to FOMEMA's <b><a target="_blank" href="${pdpaForm}" style="color:blue">Terms of Service & Privacy Policy</a></b>.</p>`);
        } else if (type == 'agency') {
            dialogBox.append(`<p><input type="checkbox" id="chkAgree"/> By initiating appeal, I, (Private Employment Agency), on behalf of employer agree to FOMEMA's <b><a target="_blank" href="${pdpaForm}" style="color:blue">Terms of Service & Privacy Policy</a></b>.</p>`);
        } else {
            dialogBox.append(`<p>Review exam results and initialize appeal process for ${name}?</p>`);
        }

        $('#dialog-appeal').dialog({
            title: title,
            modal: true,
            minWidth: 600,
            dialogClass: `dialog__title-primary shadow`,
            buttons: {
                Close: function() {
                   $(this).dialog('close');
                },
                Begin: function() {
                    if ($('#chkAgree').is(':checked')) {
                        window.location = url;
                    } else {
                        if (type == 'employer' || type == 'agency') {
                            dialogBox.append(`<p style="color: red; font-style: italic; font-size: small">You have to agree to FOMEMA's Terms of Service & Privacy Policy in order to initiate the appeal.</p>`);
                        } else {
                            window.location = url;
                        }
                    }
                }
            }
        });
    }
});

$('.doctor-exam-date-field-wipe').change(function() {
    var value = $(this).val();

    if (value === 'false') {
        // datepicker
        $(this).closest('.boolean-field-parent').find('.datepicker').val('');
        // $(`#${ $(this).attr('id') }_date`).val('');
    }
});