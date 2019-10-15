function findAddressByPostalCode(postalCodeField) {
  const postalCode = postalCodeField.value.replace(/\D/g, "");
  const id = postalCodeField.id.split("_")[3];
  const $neighborhood = document.querySelector(
    `[name="member[addresses_attributes][${id}][neighborhood]"]`
  );
  const $street = document.querySelector(
    `[name="member[addresses_attributes][${id}][street]"]`
  );
  const $city = document.querySelector(
    `[name="member[addresses_attributes][${id}][city]"]`
  );
  const $state = document.querySelector(
    `[name="member[addresses_attributes][${id}][state]"]`
  );
  if (postalCode) {
    fetch(`https://viacep.com.br/ws/${postalCode}/json/`)
      .then(response => {
        return response.json();
      })
      .then(address => {
        if (address.erro) throw new Error();

        $neighborhood.value = address.bairro;
        $street.value = address.logradouro;
        $city.value = address.localidade;
        $state.value = address.uf;
      })
      .catch(error => {
        $neighborhood.value = "";
        $street.value = "";
        $city.value = "";
        $state.value = "";
        const errorMessage =
          "Não foi possível encontrar um endereço para o CEP informado.";
        let divErrorElement = document.createElement("div");
        divErrorElement.innerHTML = `<div class='alert alert-danger alert-dismissible in' role='alert' style='display: block'><button aria-label='Close' class='close' data-dismiss='alert'><span aria-hidden='true'>&times;</span></button>${errorMessage}</div>`;
        postalCodeField.parentElement.parentElement.firstElementChild.append(
          divErrorElement
        );
      });
  } else {
    $neighborhood.value = "";
    $street.value = "";
    $city.value = "";
    $state.value = "";
  }
}

function addressNumberField(postalCodeField) {
  const id = postalCodeField.id.split("_")[3];
  return document.querySelector(`#member_addresses_attributes_${id}_number`);
}

function focusToNextFieldIfPosssible(postalCodeField) {
  if (postalCodeField.value.length == postalCodeField.maxLength) {
    addressNumberField(postalCodeField).focus();
  }
}

function formatPostalCode(postalCodeField) {
  const value = postalCodeField.value
    .replace(/\D/g, "")
    .replace(/^(\d{5})(\d)/g, "$1-$2")
    .replace(/^(\d)-(\d{3})$/, "$1-$2");
  postalCodeField.value = value;
}

function formatPhone(numberField) {
  const value = numberField.value
    .replace(/\D/g, "")
    .replace(/^(\d{2})(\d)/g, "($1) $2")
    .replace(/(\d)(\d{4})$/, "$1-$2");
  numberField.value = value;
}

function formatCPF(numberField) {
  const value = numberField.value
    .replace(/\D/g, "")
    .replace(/(\d{3})(\d)/, "$1.$2")
    .replace(/(\d{3})(\d)/, "$1.$2")
    .replace(/(\d{3})(\d{1,2})$/, "$1-$2");
  numberField.value = value;
}

function documentType(numberField) {
  const id = numberField.id.split("_")[4];
  const documentTypeField = document.querySelector(
    `#member_identity_documents_attributes_${id}_identity_document_type_id`
  );
  return documentTypeField.options[documentTypeField.selectedIndex].outerText;
}

function changeFormattingByDocumentType(documentTypeField) {
  const id = documentTypeField.id.split("_")[4];
  const numberField = document.querySelector(
    `#member_identity_documents_attributes_${id}_number`
  );
  const complementField = document.querySelector(
    `#member_identity_documents_attributes_${id}_complement`
  );
  const documentType = documentTypeField.selectedOptions[0].label;
  switch (documentType) {
    case "CPF":
      numberField.setAttribute("maxLength", 14);
      numberField.placeholder = "ex: 123.456.789-01";
      complementField.placeholder = "";
      break;
    case "Certidão de Nascimento":
      numberField.setAttribute("maxLength", 100);
      numberField.placeholder = "ex. NR. 123.456";
      complementField.placeholder = "ex. FL. 99, LV. A-77";
      break;
    default:
      numberField.setAttribute("maxLength", 14);
      numberField.placeholder = "ex: 12345678-9";
      complementField.placeholder = "ex: SSP-SP";
  }
  numberField.value = "";
}

function showTab(name) {
  $(`#tab_${name}`).click();
}
