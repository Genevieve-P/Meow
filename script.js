const toggleButton=document.getElementyById("bgToggle");
const body=document.body;

toggleButton.addEventListener("click, () => {
    body.classList.toggle("bg-one");
    body.classList.toggle("bg-two");
});