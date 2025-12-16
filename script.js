const toggleButton = document.getElementById("bgToggle");
const body = document.body;

if (toggleButton) {
    toggleButton.addEventListener("click", () => {
        body.classList.toggle("bg-one");
        body.classList.toggle("bg-two");
    });
} else {
    console.warn('bgToggle button not found');
}