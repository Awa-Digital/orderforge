document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".availability-toggle").forEach(function (toggle) {
    toggle.addEventListener("click", function (e) {
      e.preventDefault();
      const franchisePriceId = this.dataset.franchisePriceId;
      const url = this.dataset.url;

      fetch(`${url}?franchise_price_id=${franchisePriceId}`, {
        method: "PUT",
        headers: {
          "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
          Accept: "application/json",
        },
      })
        .then((response) => response.json())
        .then((data) => {
          const iconContainer = this.querySelector(".availability-toggle-icon");
          if (data.available) {
            this.classList.remove("border-slate-500");
            this.classList.remove("border");
            this.classList.add("bg-green-500");
            this.classList.add("text-white");
            iconContainer.innerHTML = `
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-check">
                <path d="M20 6 9 17l-5-5"/>
              </svg>
            `;
          } else {
            this.classList.remove("bg-green-500");
            this.classList.remove("text-white");
            this.classList.add("border-slate-500");
            this.classList.add("border");
            iconContainer.innerHTML = `
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-x">
                <path d="M18 6 6 18"/>
                <path d="M6 6l12 12"/>
              </svg>
            `;
          }
        })
        .catch((error) => console.error("Error:", error));
    });
  });
});
