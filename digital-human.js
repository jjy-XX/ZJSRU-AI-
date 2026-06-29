import * as THREE from 'three';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';

const OLLAMA_URL = 'http://127.0.0.1:11434/api/chat';
const MODEL_NAME = 'qwen2.5:7b';

let scene, camera, renderer, avatar;
let isSpeaking = false;
let chatHistory = [];
let isOllamaConnected = false;
let animationId;
let mouthAnimId;
let breathTime = 0;

const SYSTEM_PROMPT = `你是浙江树人学院的校园向导数字人，只回答以下校园相关问题：
1. 教学楼（位置、开放时间、教室查询）
2. 图书馆（位置、借阅规则、开放时间）
3. 选课（选课流程、时间、课程查询）
4. 食堂（位置、菜品、开放时间）
5. 自习室（位置、预约方式、开放时间）
6. 社团（社团列表、招新时间、活动）

回答要求：
- 精简回答，控制在2-3句话
- 语气友好温和
- 超出上述校园业务范围时，礼貌回绝并说明你只能回答校园相关问题`;

function initDigitalHuman() {
    initThreeJS();
    checkOllama();
    startIdleAnimation();
}

function initThreeJS() {
    const canvas = document.getElementById('vrmCanvas');
    
    scene = new THREE.Scene();
    scene.background = new THREE.Color(0xe0f4ff);
    
    camera = new THREE.PerspectiveCamera(45, canvas.clientWidth / canvas.clientHeight, 0.1, 1000);
    camera.position.set(0, 1.2, 3);
    
    renderer = new THREE.WebGLRenderer({ canvas, antialias: true, alpha: true });
    renderer.setSize(canvas.clientWidth, canvas.clientHeight);
    renderer.setPixelRatio(window.devicePixelRatio);
    renderer.shadowMap.enabled = true;
    
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
    scene.add(ambientLight);
    
    const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
    directionalLight.position.set(5, 10, 7);
    directionalLight.castShadow = true;
    scene.add(directionalLight);
    
    const floorGeometry = new THREE.PlaneGeometry(10, 10);
    const floorMaterial = new THREE.MeshStandardMaterial({ 
        color: 0xeeeeee,
        roughness: 0.8
    });
    const floor = new THREE.Mesh(floorGeometry, floorMaterial);
    floor.rotation.x = -Math.PI / 2;
    floor.position.y = 0;
    floor.receiveShadow = true;
    scene.add(floor);
    
    window.addEventListener('resize', onWindowResize);
    
    loadGLBModel();
}

function loadGLBModel() {
    const loading = document.getElementById('canvasLoading');
    const warning = document.getElementById('canvasWarning');
    
    const loader = new GLTFLoader();
    
    loader.load('model/avatar.glb', (gltf) => {
        avatar = gltf.scene;
        
        avatar.traverse((object) => {
            if (object.isMesh) {
                object.castShadow = true;
                object.receiveShadow = true;
            }
        });
        
        const box = new THREE.Box3().setFromObject(avatar);
        const size = box.getSize(new THREE.Vector3());
        const center = box.getCenter(new THREE.Vector3());
        
        const maxSize = Math.max(size.x, size.y, size.z);
        const scale = 2.5 / maxSize;
        
        avatar.scale.set(scale, scale, scale);
        avatar.position.y = -center.y * scale;
        avatar.rotation.y = Math.PI;
        
        scene.add(avatar);
        loading.style.display = 'none';
    }, undefined, (error) => {
        console.warn('GLB load failed:', error);
        loading.style.display = 'none';
        warning.style.display = 'block';
        createCSSCharacter();
    });
}

function createCSSCharacter() {
    const viewport = document.querySelector('.human-viewport');
    const character = document.createElement('div');
    character.style.cssText = `
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 200px;
        height: 320px;
        animation: idleFloat 4s ease-in-out infinite;
    `;
    character.innerHTML = `
        <style>
            @keyframes idleFloat { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-8px)} }
            @keyframes blink { 0%,45%,55%,100%{height:10px} 50%{height:2px} }
            @keyframes mouthMove { 0%,100%{height:12px} 50%{height:18px} }
            .css-head{position:relative;width:100px;height:110px;margin:0 auto;background:#ffe0bd;border-radius:50% 50% 45% 45%}
            .css-hair{position:absolute;top:-15px;left:-8px;right:-8px;height:60px;background:#4a3728;border-radius:50% 50% 30% 30%}
            .css-eyes{position:absolute;top:42px;left:50%;transform:translateX(-50%);display:flex;gap:24px}
            .css-eye{width:18px;height:18px;background:white;border-radius:50%;position:relative;overflow:hidden}
            .css-pupil{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);width:10px;height:10px;background:#2c3e50;border-radius:50%;animation:blink 4s infinite}
            .css-nose{position:absolute;top:58px;left:50%;transform:translateX(-50%);width:12px;height:16px;background:#f0c898;border-radius:50%}
            .css-mouth{position:absolute;bottom:20px;left:50%;transform:translateX(-50%);width:28px;height:12px;background:#e57373;border-radius:0 0 50% 50%}
            .css-body{width:120px;height:140px;margin:-5px auto;background:linear-gradient(135deg,#4a90d9,#6c5ce7);border-radius:20px 20px 10px 10px}
            .css-collar{width:36px;height:30px;background:white;margin:0 auto;clip-path:polygon(0 0,100% 0,80% 100%,20% 100%)}
            .css-speaking .css-mouth{animation:mouthMove 0.2s infinite}
            .css-speaking{animation:speakBounce 0.5s ease-in-out infinite}
            @keyframes speakBounce { 0%,100%{transform:translateY(0) scale(1)} 50%{transform:translateY(-4px) scale(1.02)} }
        </style>
        <div class="css-head">
            <div class="css-hair"></div>
            <div class="css-eyes"><div class="css-eye"><div class="css-pupil"></div></div><div class="css-eye"><div class="css-pupil"></div></div></div>
            <div class="css-nose"></div>
            <div class="css-mouth"></div>
        </div>
        <div class="css-body">
            <div class="css-collar"></div>
        </div>
    `;
    character.id = 'cssCharacter';
    viewport.appendChild(character);
}

function onWindowResize() {
    const canvas = document.getElementById('vrmCanvas');
    if (!canvas) return;
    camera.aspect = canvas.clientWidth / canvas.clientHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(canvas.clientWidth, canvas.clientHeight);
}

function startIdleAnimation() {
    function animate() {
        animationId = requestAnimationFrame(animate);
        breathTime += 0.016;
        
        if (avatar) {
            if (!isSpeaking) {
                const breathScale = 1 + Math.sin(breathTime * 2) * 0.015;
                avatar.scale.setScalar(breathScale);
                avatar.position.y = Math.sin(breathTime * 2) * 0.02;
            }
        }
        
        if (renderer) {
            renderer.render(scene, camera);
        }
    }
    
    animate();
}

function startSpeaking() {
    isSpeaking = true;
    
    const cssChar = document.getElementById('cssCharacter');
    if (cssChar) {
        cssChar.classList.add('css-speaking');
    }
    
    if (avatar) {
        startMouthAnimation();
    }
}

function stopSpeaking() {
    isSpeaking = false;
    
    const cssChar = document.getElementById('cssCharacter');
    if (cssChar) {
        cssChar.classList.remove('css-speaking');
    }
    
    if (avatar) {
        avatar.scale.setScalar(1);
        avatar.position.y = 0;
        if (mouthAnimId) clearInterval(mouthAnimId);
    }
}

function startMouthAnimation() {
    if (mouthAnimId) clearInterval(mouthAnimId);
    
    mouthAnimId = setInterval(() => {
        if (!isSpeaking || !avatar) {
            clearInterval(mouthAnimId);
            return;
        }
        
        const speakScale = 1 + Math.sin(Date.now() * 0.015) * 0.025;
        avatar.scale.setScalar(speakScale);
        avatar.position.y = Math.sin(Date.now() * 0.015) * 0.03;
    }, 50);
}

async function checkOllama() {
    const statusDot = document.getElementById('statusDot');
    const statusText = document.querySelector('.model-status span:last-child');
    const errorOverlay = document.getElementById('errorOverlay');
    
    try {
        const response = await fetch('http://127.0.0.1:11434/api/tags', { method: 'GET' });
        if (response.ok) {
            isOllamaConnected = true;
            if (statusDot) statusDot.classList.remove('offline');
            if (statusText) statusText.textContent = 'Ollama 已连接';
            if (errorOverlay) errorOverlay.classList.remove('show');
        } else {
            throw new Error('Ollama not running');
        }
    } catch (error) {
        isOllamaConnected = false;
        if (statusDot) statusDot.classList.add('offline');
        if (statusText) statusText.textContent = 'Ollama 未连接';
    }
}

function handleHumanKeydown(event) {
    if (event.key === 'Enter') {
        sendMessage();
    }
}

function sendQuickMessage(message) {
    const input = document.getElementById('humanInput');
    if (input) {
        input.value = message;
        sendMessage();
    }
}

async function sendMessage() {
    const input = document.getElementById('humanInput');
    const message = input ? input.value.trim() : '';
    
    if (!message) return;
    
    if (input) input.value = '';
    addMessage(message, 'user');
    
    if (!isOllamaConnected) {
        showOllamaError();
        return;
    }
    
    const thinkingId = showThinkingIndicator();
    
    startSpeaking();
    
    try {
        const response = await fetch(OLLAMA_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                model: MODEL_NAME,
                messages: [
                    { role: 'system', content: SYSTEM_PROMPT },
                    ...chatHistory.slice(-6),
                    { role: 'user', content: message }
                ],
                stream: true,
                options: {
                    temperature: 0.7,
                    max_tokens: 200
                }
            })
        });
        
        if (!response.ok) {
            throw new Error('Ollama request failed');
        }
        
        removeThinkingIndicator(thinkingId);
        
        const reader = response.body.getReader();
        const decoder = new TextDecoder('utf-8');
        let fullResponse = '';
        const messageId = addEmptyBotMessage();
        
        while (true) {
            const { done, value } = await reader.read();
            if (done) break;
            
            const chunk = decoder.decode(value);
            const lines = chunk.split('\n').filter(line => line.trim());
            
            for (const line of lines) {
                try {
                    const data = JSON.parse(line);
                    if (data.message && data.message.content) {
                        fullResponse += data.message.content;
                        updateBotMessage(messageId, fullResponse);
                    }
                    if (data.done) break;
                } catch (e) {
                    console.warn('Parse error:', e);
                }
            }
        }
        
        chatHistory.push({ role: 'user', content: message });
        chatHistory.push({ role: 'assistant', content: fullResponse });
        
        stopSpeaking();
    } catch (error) {
        console.error('Chat error:', error);
        removeThinkingIndicator(thinkingId);
        addMessage('抱歉，请求出现问题，正在重新检测连接...', 'bot');
        stopSpeaking();
        checkOllama();
    }
}

function showOllamaError() {
    const errorOverlay = document.getElementById('errorOverlay');
    if (errorOverlay) errorOverlay.classList.add('show');
}

function showThinkingIndicator() {
    const messagesContainer = document.getElementById('humanMessages');
    if (!messagesContainer) return null;
    
    const thinkingDiv = document.createElement('div');
    thinkingDiv.className = 'human-msg bot';
    thinkingDiv.innerHTML = `
        <div class="msg-bubble">
            <div class="thinking-indicator">
                <span></span><span></span><span></span>
            </div>
        </div>
    `;
    thinkingDiv.id = 'thinking-' + Date.now();
    messagesContainer.appendChild(thinkingDiv);
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
    return thinkingDiv.id;
}

function removeThinkingIndicator(id) {
    if (!id) return;
    const el = document.getElementById(id);
    if (el) el.remove();
}

function addMessage(content, sender) {
    const messagesContainer = document.getElementById('humanMessages');
    if (!messagesContainer) return;
    
    const messageDiv = document.createElement('div');
    messageDiv.className = `human-msg ${sender}`;
    
    messageDiv.innerHTML = `
        <div class="msg-bubble">
            <p>${content}</p>
        </div>
    `;
    
    messagesContainer.appendChild(messageDiv);
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

function addEmptyBotMessage() {
    const messagesContainer = document.getElementById('humanMessages');
    if (!messagesContainer) return null;
    
    const messageDiv = document.createElement('div');
    messageDiv.className = 'human-msg bot';
    messageDiv.innerHTML = `
        <div class="msg-bubble">
            <p id="botMsg-${Date.now()}"></p>
        </div>
    `;
    messagesContainer.appendChild(messageDiv);
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
    return messageDiv.querySelector('p').id;
}

function updateBotMessage(id, content) {
    const el = document.getElementById(id);
    if (el) {
        el.textContent = content;
        const messagesContainer = document.getElementById('humanMessages');
        if (messagesContainer) messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }
}

function clearChat() {
    chatHistory = [];
    const messagesContainer = document.getElementById('humanMessages');
    if (messagesContainer) {
        messagesContainer.innerHTML = `
            <div class="human-msg bot">
                <div class="msg-bubble">
                    <p>你好！我是校园向导数字人。请问有什么关于教学楼、图书馆、选课、食堂、自习室或社团的问题吗？</p>
                </div>
            </div>
        `;
    }
}

window.initDigitalHuman = initDigitalHuman;
window.checkOllama = checkOllama;
window.sendMessage = sendMessage;
window.handleHumanKeydown = handleHumanKeydown;
window.sendQuickMessage = sendQuickMessage;
window.clearChat = clearChat;

window.addEventListener('DOMContentLoaded', () => {
    const scene = document.getElementById('scene-digital-human');
    if (scene && scene.classList.contains('active')) {
        initDigitalHuman();
    }
});