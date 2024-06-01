document.addEventListener('DOMContentLoaded', () => {
    const staminaBar = document.getElementById('stamina-fill');
    const staminaText = document.getElementById('stamina-text');
    const spaceKey = document.getElementById('space-key');
    let stamina = 100;

    function updateStamina(amount) {
        stamina = Math.max(0, amount);
        staminaBar.style.width = stamina + '%';
    }

    function simulateKeyPress() {
        spaceKey.classList.add('active');
        setTimeout(() => {
            spaceKey.classList.remove('active');
        }, 100);
    }

    document.addEventListener('keydown', (event) => {
        if (event.code === 'Space') {
            event.preventDefault();
            updateStamina(stamina - 10);
            simulateKeyPress();
            fetch('http://localhost:3000/exercise', { method: 'POST' })
                .then(response => response.json())
                .then(data => console.log(data))
                .catch(error => console.error('Error:', error));
        }
    });

    window.addEventListener('message', (event) => {
        const data = event.data;
        if (data.action === 'show') {
            document.body.style.display = 'flex';
        } else if (data.action === 'hide') {
            document.body.style.display = 'none';
        } else if (data.action === 'updateStamina') {
            updateStamina(data.value);
        } else if (data.action === 'pressSpaceKey') {
            simulateKeyPress();
        }
    });


    updateStamina(100);
});
