Array.prototype.eachSlice = function (size, callback){
  for (var i = 0, l = this.length; i < l; i += size){
    callback.call(this, this.slice(i, i + size));
  }
};

window.onload = function() {
  Journalist = require('./src/journalist');
  window.journalist = new Journalist();

  journalist.startProfiler();
}
