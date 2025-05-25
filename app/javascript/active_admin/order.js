document.addEventListener("DOMContentLoaded", function () {
  const btn = document.getElementById("generate-report-btn");
  if (!btn) return;

  btn.addEventListener("click", function () {
    const params = new URLSearchParams(window.location.search);
    const form = document.createElement("form");
    form.method = "POST";
    form.action = "/admin/orders/generate_report";

    const csrfToken = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    const csrfInput = document.createElement("input");
    csrfInput.type = "hidden";
    csrfInput.name = "authenticity_token";
    csrfInput.value = csrfToken;
    form.appendChild(csrfInput);

    for (const [key, value] of params.entries()) {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = key;
      input.value = value;
      form.appendChild(input);
    }

    document.body.appendChild(form);
    form.submit();
  });
});
