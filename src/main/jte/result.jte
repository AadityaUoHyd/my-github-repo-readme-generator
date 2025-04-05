@param String content

<div class="glass-container">
    <div class="relative">
        <textarea
                id="result"
                class="result-box"
                readonly
        >${content}</textarea>

        <button
                onclick="copyContent()"
                id="copy-button"
                class="btn-copy"
        >
            Copy Content
        </button>
    </div>
</div>

<script>
    function copyContent() {
        const textarea = document.getElementById('result');
        textarea.select();
        navigator.clipboard.writeText(textarea.value).then(() => {
            const button = document.getElementById('copy-button');
            button.innerHTML = '✅ Copied!';
            button.classList.add('copied');

            setTimeout(() => {
                button.innerHTML = 'Copy Content';
                button.classList.remove('copied');
            }, 2000);
        });
    }
</script>

<style>
    /* Glassmorphic Container */
    .glass-container {
        background: rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border-radius: 16px;
        box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
        padding: 2rem;
        max-width: 700px;
        width: 100%;
        border: 1px solid rgba(255, 255, 255, 0.3);
        animation: fadeIn 0.4s ease-in-out;
    }

    /* Textarea Styling */
    .result-box {
        width: 100%;
        height: 350px;
        padding: 12px;
        border-radius: 8px;
        border: 1px solid rgba(255, 255, 255, 0.3);
        background: rgba(255, 255, 255, 0.2);
        color: white;
        font-family: 'Fira Code', monospace;
        font-size: 14px;
        outline: none;
        transition: border 0.3s ease;
        resize: none;
    }

    .result-box:focus {
        border: 1px solid rgba(255, 255, 255, 0.6);
    }

    /* Copy Button */
    .btn-copy {
        margin-top: 12px;
        padding: 10px 16px;
        background: linear-gradient(90deg, #3B82F6, #9333EA);
        color: white;
        font-weight: bold;
        border-radius: 8px;
        text-transform: uppercase;
        cursor: pointer;
        transition: background 0.3s ease, transform 0.2s ease;
    }

    .btn-copy:hover {
        background: linear-gradient(90deg, #9333EA, #3B82F6);
        transform: scale(1.05);
    }

    /* Copied Animation */
    .copied {
        background: linear-gradient(90deg, #10B981, #047857);
        transform: scale(1);
    }

    /* Fade-in Animation */
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>
