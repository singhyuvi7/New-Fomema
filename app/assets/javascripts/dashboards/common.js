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

    const selectAllCheckbox = document.getElementById('select-all');
    const isSelectAllChecked = selectAllCheckbox.checked;

    // Handle "Select All" checkbox separately
    if (dataTarget === 'selectAll') {
        allSections.forEach((section) => {
            if (isSelectAllChecked) {
                section.classList.add('show');
            } else {
                section.classList.remove('show');
            }
        });

        const allCheckboxesXQCC = document.querySelectorAll('.checkbox-xqcc');
        allCheckboxesXQCC.forEach((checkbox) => {
            checkbox.checked = isSelectAllChecked;
        });

        const allCheckboxesPCR = document.querySelectorAll('.checkbox-pcr');
        allCheckboxesPCR.forEach((checkbox) => {
            checkbox.checked = isSelectAllChecked;
        });

        const allCheckboxesXray = document.querySelectorAll('.checkbox-xray');
        allCheckboxesXray.forEach((checkbox) => {
            checkbox.checked = isSelectAllChecked;
        });

        const allCheckboxesXrayDecision = document.querySelectorAll('.checkbox-xray-decision');
        allCheckboxesXrayDecision.forEach((checkbox) => {
            checkbox.checked = isSelectAllChecked;
        });

        const allCheckboxesMedical = document.querySelectorAll('.checkbox-medical');
        allCheckboxesMedical.forEach((checkbox) => {
            checkbox.checked = isSelectAllChecked;
        });
    } else {
        const section = document.getElementById(dataTarget);

        // Toggle the 'show' class on the clicked section
        if (section.classList.contains('show')) {
            section.classList.remove('show');
        } else {
            section.classList.add('show');
        }

        const checkbox = section.querySelector('.section-checkbox');
        if (checkbox) {
            checkbox.checked = !checkbox.checked;
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

