export default {
  mounted(){
    this.handleEvent("clear_after_sending_system_message", () => {this.el.value = ""});
  }
}