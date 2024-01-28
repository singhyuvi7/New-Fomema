// console.log('javascripts/external/sessions.js loaded');
setLoginUsernameEmailPlaceholder($('#external_user_login_type').val());

$('#external_user_login_type').change(function() {
    type = $(this).val();
    setLoginUsernameEmailPlaceholder(type);
});

function setLoginUsernameEmailPlaceholder(type) {
	placeholder = type === 'Code' ? 'Code' : 'Email';
	$('#external_user_login').attr('placeholder', placeholder);
}