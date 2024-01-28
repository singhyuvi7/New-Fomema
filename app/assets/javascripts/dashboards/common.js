function fnbackredirect(){
    window.location.href="https://nios-uat.fomema.my";
}
function refreshClick(){
    if($('#refreshopen').hasClass("show")){
        $('#refreshopen').removeClass("show")
    }
    else{
        $("#refreshopen").addClass("show");
    }
}
function radiographerClick(dataTarget) {
    const ulContainer = document.querySelector('.sub-ulcard');
    const allSections = ulContainer.querySelectorAll('.collapse');

    if (dataTarget === 'selectAll') {
        const selectAllCheckbox = document.getElementById('select-all');
        const isSelectAllChecked = selectAllCheckbox.checked;

        allSections.forEach((section) => {
            if (isSelectAllChecked) {
                section.classList.add('show');
            } else {
                section.classList.remove('show');
            }
        });
    } else {
        const section = document.getElementById(dataTarget);

        // Toggle the 'show' class on the clicked section
        if (section.classList.contains('show')) {
            section.classList.remove('show');
        } else {
            section.classList.add('show');
        }
    }
}
function CommunicableOpenClose() {
    if ($('#collapseOne19').hasClass("show")) {
        $('#collapseOne19').removeClass("show")
    } else {
        $("#collapseOne19").addClass("show");
    }
}

function NonCommunicableOpenClose() {
    if ($('#collapseTwo19').hasClass("show")) {
        $('#collapseTwo19').removeClass("show")
    } else {
        $("#collapseTwo19").addClass("show");
    }
}

