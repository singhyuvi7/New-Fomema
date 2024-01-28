// console.log('javascript/internal/fomema.js loaded');

/* $("td[data-link]").click(function() {
    window.location = $(this).data("link")
}); */

function external_change_fee(sel)
{
    if ($('#order_payment_method_id').val() != ''){
        $('#chk-conditional-renewal').attr('required', false);
        $('#chk-special-renewal-form').attr('required', false);
        $('#chk-validity-form').attr('required', false);
        $('#chk-add-consent-box-form').attr('required', false);
        $('#btn-save').trigger('click');
        $('.btn').prop('disabled', true);
    }
}
