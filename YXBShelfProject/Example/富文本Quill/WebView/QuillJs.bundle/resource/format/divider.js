let BlockEmbed = Quill.import('blots/block/embed')

class Divider extends BlockEmbed {

    static create(value) {
        const node = super.create(value);
        node.setAttribute('style', 'border: 1px solid #eee; margin: 12px 0;');
        return node;
    }
}

Divider.blotName = 'divider'
Divider.tagName = 'hr'

Quill.register({ 'formats/divider': Divider })



