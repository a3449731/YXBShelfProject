

Quill.prototype.getHtml = function() {
    return this.container.querySelector('.ql-editor').innerHTML;
};

// 要在加载完成之前能获取到想要的信息，需要js先向app内发起消息查询
function getAppThemeBeforeLoaded() {
    window.webkit.messageHandlers.getAppThemeBeforeLoaded.postMessage(null);
}

// 主题
function changeTheme(theme) {
    document.getElementById("scrolling-container").className = `rich_text_theme_${theme}`;
}

getAppThemeBeforeLoaded()

// 从原生端打印日志
function sendMessage(name, params = ""){
    window.webkit.messageHandlers[name].postMessage(params)
}

// 监听文本编辑
quill.on("editor-change", event => {
    window.sendMessage('logger', quill.getFormat())
    window.sendMessage('actions', quill.getFormat())
});

quill.on("selection-change", event => {
    window.sendMessage('logger', 'selection-change')
//    let topPosition = window.getCaretYPosition()
    
    const selection = window.getSelection()
    const range = selection.getRangeAt(0)
    const rect = range.getBoundingClientRect()
    const topPosition = rect.top
});

// 失去焦点
function blur() {
    quill.blur()
}

// 获得焦点
function focus() {
    window.sendMessage('logger', '聚焦')
    // 这个无效
//    quill.focus()
    quill.container.querySelector('.ql-editor').focus()
}

// 是否获得焦点
function hasFocus() {
    var focus = quill.hasFocus()
//    window.sendMessage('logger', focus)
}

// 更新
function update() {
    quill.update()
}

// format
function setBold(val) {
    quill.format('bold', val)
}

// Br
function setBr(val) {    
    const range = quill.getSelection(true);
    // The third parameter source is set to user, which means: ignore the call when the editor is disabled
    quill.insertText(range.index, '\n', Quill.sources.USER);    // insert blank line
    quill.insertEmbed(range.index + 1, 'divider', true, Quill.sources.USER);    // Insert dividing line
    quill.setSelection(range.index + 2, Quill.sources.USER);    // Set cursor position
}

function setItalic(val) {
    quill.format('italic', val)
}

function setScript(val) {
    quill.format('script', val)
}

function setUnderline(val) {
    quill.format('underline', val)
}

function setStrike(val){
    quill.format('strike', val)
}

function setIndent(val){
    quill.format('indent', val)
}
function setHeader(val) {
    quill.format('header', val);
}

function setSize(val) {
    quill.format('size', val);
}

function setAlign(val) {
    quill.format('align', val);
}

function setBlockquote(val) {
    quill.format('blockquote', val);
}

function setCodeblock(val) {
    quill.format('code-block', val);
}

// ordered & bullet
function setList(val){
    quill.format('list', val)
}

// undo
function undo() {
    quill.history.undo();
}

// redo
function redo() {
   quill.history.redo()
}


function setLink(val) {
    quill.format('link', val)
}

function setColor(val){
    quill.format('color', val)
}

function setBackgroundColor(val){
    quill.format('background', val)
}

function removeAllFormat() {
    var selection = quill.getSelection()
    quill.removeFormat(0,selection.index)
}

function insertImage(path){
//    setTimeout(() => {
        const range = quill.getSelection(true);
        quill.insertText(range.index, '\n', Quill.sources.USER);    // insert blank line
        quill.insertEmbed(range.index + 1, 'image', path);
        sendMessage("logger", range)
        quill.insertText(range.index + 2, '\n', Quill.sources.USER);    // insert blank line
        quill.setSelection(range.index + 3, Quill.sources.USER);    // Set cursor position
//    }, 1000)
    
        
    /*
    var selection = quill.getSelection()
    quill.insertEmbed(selection, 'image', path);
    selection = quill.getSelection()
    quill.setSelection(selection.index+2,1)
    */
}

// 导出
function getHtml() {
    var html = quill.getHtml()
    return html
}

// 导入
function insertContent(content){
    quill.container.querySelector('.ql-editor').innerHTML = content
}

