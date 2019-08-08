function findAddressByPostalCode(postalCodeField) {
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
  if (postalCodeField.value.trim()) {
    fetch(`https://viacep.com.br/ws/${postalCodeField.value}/json/`)
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
        alert("Não foi possível encontrar um endereço para o CEP informado.");
      });
  }
}
