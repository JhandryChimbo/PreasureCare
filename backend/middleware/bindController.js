function bindController(controller) {
    const boundMethods = {};
    for (const key of Object.getOwnPropertyNames(Object.getPrototypeOf(controller))) {
      if (typeof controller[key] === "function" && key !== "constructor") {
        boundMethods[key] = controller[key].bind(controller);
      }
    }
    return boundMethods;
  }
  
  module.exports = bindController;
  