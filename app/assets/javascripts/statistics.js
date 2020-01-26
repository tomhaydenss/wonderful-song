function selectEnsembleParent(ensembleParent) {
  const option = ensembleParent.selectedOptions[0].value;
  if (option) {
    ensembleParent.form.submit();
  }
}

function showTab(name) {
  $(`#tab_${name}`).click();
}