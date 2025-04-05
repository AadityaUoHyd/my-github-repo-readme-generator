@import gg.jte.Content

@template.layout.page(
title = "Github README Generator",
content = @`
    <div class="text-center mb-12">
        <p class="text-gray-200 drop-shadow-sm">Generate a consolidated README file for a GitHub repository or a local directory.</p>
    </div>

    <div class="glass-container">
        <div class="mb-6 flex justify-center space-x-4">
            <button onclick="switchTab('github')"
                    id="github-tab"
                    class="px-6 py-2 text-sm font-medium rounded-lg transition duration-300 github-tab-button">
                GitHub Repository
            </button>
            <button onclick="switchTab('local')"
                    id="local-tab"
                    class="px-6 py-2 text-sm font-medium rounded-lg transition duration-300 local-tab-button">
                Local Directory
            </button>
        </div>

        <form hx-post="/generate" hx-target="#result-container" hx-indicator="#spinner">
            <div id="github-input" class="tab-content">
                <div class="mb-6">
                    <label for="githubUrl" class="block text-sm font-medium text-gray-100 mb-2">GitHub Repository URL</label>
                    <input
                            type="text"
                            id="githubUrl"
                            name="githubUrl"
                            class="input-box"
                            placeholder="https://github.com/username/repo"
                    >
                </div>
            </div>

            <div id="local-input" class="tab-content hidden">
                <div class="mb-6">
                    <label for="localPath" class="block text-sm font-medium text-gray-100 mb-2">Local Directory Path</label>
                    <input
                            type="text"
                            id="localPath"
                            name="localPath"
                            class="input-box"
                            placeholder="/path/to/your/directory"
                    >
                </div>
            </div>

            <button type="submit" class="btn-primary">
                Generate README File Content
            </button>
        </form>

        <div id="spinner" class="htmx-indicator flex justify-center mt-6">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
        </div>

        <div id="result-container" class="mt-6">
            <!-- Generated content will appear here -->
        </div>
    </div>

    <script>
        function switchTab(tab) {
            const githubInput = document.getElementById('github-input');
            const localInput = document.getElementById('local-input');
            const githubTab = document.getElementById('github-tab');
            const localTab = document.getElementById('local-tab');

            if (tab === 'github') {
                githubInput.classList.remove('hidden');
                localInput.classList.add('hidden');
                document.getElementById('localPath').value = '';
                githubTab.classList.add('active-tab');
                localTab.classList.remove('active-tab');
            } else {
                githubInput.classList.add('hidden');
                localInput.classList.remove('hidden');
                document.getElementById('githubUrl').value = '';
                localTab.classList.add('active-tab');
                githubTab.classList.remove('active-tab');
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            switchTab('github');
        });
    </script>

    <style>
        /* Gradient Background */
        body {
            background: linear-gradient(-45deg, #1E3A8A, #9333EA, #EF4444);
            background-size: 400% 400%;
            animation: gradientBG 10s ease infinite;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

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
        }

        /* Input Box */
        .input-box {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.2);
            color: white;
            outline: none;
            transition: border 0.3s ease;
        }

        .input-box::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }

        .input-box:focus {
            border: 1px solid rgba(255, 255, 255, 0.6);
        }

        /* Button Styles */
        .btn-primary {
            width: 100%;
            background: linear-gradient(90deg, #3B82F6, #9333EA);
            color: white;
            font-weight: bold;
            padding: 12px;
            border-radius: 8px;
            text-transform: uppercase;
            transition: background 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(90deg, #9333EA, #3B82F6);
        }

        /* Active Tab */
        .active-tab {
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
        }

        /* Fade-in Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-in { animation: fadeIn 0.4s ease-out forwards; }

    </style>
`
)
